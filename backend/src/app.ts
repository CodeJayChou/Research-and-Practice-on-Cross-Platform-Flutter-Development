import cors from '@fastify/cors';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import Fastify, { type FastifyInstance } from 'fastify';

import { AppError } from './common/errors/app-error.js';
import { loadAppConfig, type AppConfig } from './config/app-config.js';
import { ChannelService } from './modules/channels/application/channel-service.js';
import { channels } from './modules/channels/infrastructure/channel-seed.js';
import { channelRoutes } from './modules/channels/presentation/channel-routes.js';
import { PlaybackEventService } from './modules/playback-events/application/playback-event-service.js';
import { InMemoryPlaybackEventRepository } from './modules/playback-events/infrastructure/in-memory-playback-event-repository.js';
import { playbackEventRoutes } from './modules/playback-events/presentation/playback-event-routes.js';
import { VideoService } from './modules/videos/application/video-service.js';
import { InMemoryVideoRepository } from './modules/videos/infrastructure/in-memory-video-repository.js';
import { createVideoSeed } from './modules/videos/infrastructure/video-seed.js';
import { videoRoutes } from './modules/videos/presentation/video-routes.js';

export interface BuildAppOptions {
  readonly config?: AppConfig;
  readonly logger?: boolean;
}

export async function buildApp(
  options: BuildAppOptions = {},
): Promise<FastifyInstance> {
  const config = options.config ?? loadAppConfig();
  const app: FastifyInstance =
    options.logger === false
      ? Fastify({ logger: false })
      : config.nodeEnv === 'development'
        ? Fastify({
            logger: {
              level: config.logLevel,
              transport: {
                target: 'pino-pretty',
                options: { colorize: true, translateTime: 'SYS:standard' },
              },
            },
          })
        : Fastify({ logger: { level: config.logLevel } });

  const channelService = new ChannelService(channels);
  const videoRepository = new InMemoryVideoRepository(createVideoSeed(channels));
  const videoService = new VideoService(channelService, videoRepository);
  const playbackEventService = new PlaybackEventService(
    videoService,
    new InMemoryPlaybackEventRepository(),
  );

  await app.register(cors, {
    origin:
      config.corsOrigin === '*'
        ? '*'
        : config.corsOrigin
            .split(',')
            .map((origin) => origin.trim())
            .filter(Boolean),
  });
  await app.register(swagger, {
    openapi: {
      info: {
        title: 'Cross-platform Video API',
        description: 'Local API for channels, video feeds and playback events.',
        version: '0.1.0',
      },
      tags: [
        { name: 'System', description: 'Service status' },
        { name: 'Channels', description: 'Home channel navigation' },
        { name: 'Videos', description: 'Video feed data' },
        { name: 'Playback', description: 'Playback telemetry' },
      ],
    },
  });
  await app.register(swaggerUi, {
    routePrefix: '/docs',
    uiConfig: { docExpansion: 'list', deepLinking: true },
  });

  app.get(
    '/health',
    {
      schema: {
        tags: ['System'],
        summary: 'Check service health',
        response: {
          200: {
            type: 'object',
            required: ['status', 'service', 'uptimeSeconds', 'timestamp'],
            properties: {
              status: { type: 'string', const: 'ok' },
              service: { type: 'string' },
              uptimeSeconds: { type: 'number' },
              timestamp: { type: 'string', format: 'date-time' },
            },
          },
        },
      },
    },
    async () => ({
      status: 'ok',
      service: 'cross-platform-video-api',
      uptimeSeconds: process.uptime(),
      timestamp: new Date().toISOString(),
    }),
  );

  app.setNotFoundHandler(async (_request, reply) =>
    reply.status(404).send({
      error: { code: 'ROUTE_NOT_FOUND', message: 'Route was not found' },
    }),
  );

  app.setErrorHandler(async (error, request, reply) => {
    const isValidationError = hasValidationErrors(error);
    const reportedStatusCode = getStatusCode(error);
    const statusCode =
      error instanceof AppError
        ? error.statusCode
        : isValidationError
          ? 400
          : (reportedStatusCode ?? 500);
    const code =
      error instanceof AppError
        ? error.code
        : isValidationError
          ? 'VALIDATION_ERROR'
          : statusCode >= 500
            ? 'INTERNAL_SERVER_ERROR'
            : 'REQUEST_ERROR';

    if (statusCode >= 500) {
      request.log.error({ error }, 'Request failed');
    }

    return reply.status(statusCode).send({
      error: {
        code,
        message:
          statusCode >= 500
            ? 'Internal server error'
            : getErrorMessage(error),
      },
    });
  });

  await app.register(channelRoutes, {
    prefix: '/api/v1/channels',
    channelService,
  });
  await app.register(videoRoutes, {
    prefix: '/api/v1',
    videoService,
  });
  await app.register(playbackEventRoutes, {
    prefix: '/api/v1',
    playbackEventService,
  });

  return app;
}

function hasValidationErrors(error: unknown): boolean {
  if (typeof error !== 'object' || error === null) {
    return false;
  }
  return 'validation' in error && error.validation !== undefined;
}

function getStatusCode(error: unknown): number | undefined {
  if (
    typeof error !== 'object' ||
    error === null ||
    !('statusCode' in error) ||
    typeof error.statusCode !== 'number'
  ) {
    return undefined;
  }
  return error.statusCode;
}

function getErrorMessage(error: unknown): string {
  return error instanceof Error ? error.message : 'Request failed';
}

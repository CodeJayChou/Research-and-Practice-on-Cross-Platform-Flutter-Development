import type { FastifyPluginAsync } from 'fastify';

import type { VideoService } from '../application/video-service.js';
import { videoSchema } from './video-schema.js';

interface VideoRouteOptions {
  readonly videoService: VideoService;
}

interface ChannelVideoParams {
  readonly channelId: string;
}

interface VideoParams {
  readonly videoId: string;
}

interface VideoPageQuery {
  readonly cursor?: string;
  readonly limit?: number;
}

export const videoRoutes: FastifyPluginAsync<VideoRouteOptions> = async (
  app,
  options,
) => {
  app.get<{ Params: ChannelVideoParams; Querystring: VideoPageQuery }>(
    '/channels/:channelId/videos',
    {
      schema: {
        tags: ['Videos'],
        summary: 'List videos in a channel',
        params: {
          type: 'object',
          required: ['channelId'],
          properties: { channelId: { type: 'string', minLength: 1 } },
        },
        querystring: {
          type: 'object',
          properties: {
            cursor: { type: 'string', minLength: 1 },
            limit: { type: 'integer', minimum: 1, maximum: 20, default: 10 },
          },
        },
        response: {
          200: {
            type: 'object',
            required: ['data', 'pagination'],
            properties: {
              data: { type: 'array', items: videoSchema },
              pagination: {
                type: 'object',
                required: ['nextCursor', 'hasMore'],
                properties: {
                  nextCursor: { anyOf: [{ type: 'string' }, { type: 'null' }] },
                  hasMore: { type: 'boolean' },
                },
              },
            },
          },
        },
      },
    },
    async (request) =>
      options.videoService.listByChannel(
        request.params.channelId,
        request.query.cursor,
        request.query.limit ?? 10,
      ),
  );

  app.get<{ Params: VideoParams }>(
    '/videos/:videoId',
    {
      schema: {
        tags: ['Videos'],
        summary: 'Get a video by id',
        params: {
          type: 'object',
          required: ['videoId'],
          properties: { videoId: { type: 'string', minLength: 1 } },
        },
        response: {
          200: {
            type: 'object',
            required: ['data'],
            properties: { data: videoSchema },
          },
        },
      },
    },
    async (request) => ({
      data: options.videoService.getById(request.params.videoId),
    }),
  );
};

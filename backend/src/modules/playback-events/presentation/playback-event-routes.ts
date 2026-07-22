import type { FastifyPluginAsync } from 'fastify';

import type { PlaybackEventService } from '../application/playback-event-service.js';
import {
  playbackEventTypes,
  type PlaybackEventInput,
} from '../domain/playback-event.js';

interface PlaybackEventRouteOptions {
  readonly playbackEventService: PlaybackEventService;
}

interface VideoParams {
  readonly videoId: string;
}

export const playbackEventRoutes: FastifyPluginAsync<
  PlaybackEventRouteOptions
> = async (app, options) => {
  app.post<{ Params: VideoParams; Body: PlaybackEventInput }>(
    '/videos/:videoId/playback-events',
    {
      schema: {
        tags: ['Playback'],
        summary: 'Record a video playback event',
        params: {
          type: 'object',
          required: ['videoId'],
          properties: { videoId: { type: 'string', minLength: 1 } },
        },
        body: {
          type: 'object',
          additionalProperties: false,
          required: ['sessionId', 'type', 'positionMs'],
          properties: {
            sessionId: { type: 'string', minLength: 1, maxLength: 128 },
            type: { type: 'string', enum: [...playbackEventTypes] },
            positionMs: { type: 'integer', minimum: 0 },
            durationMs: { type: 'integer', minimum: 0 },
            occurredAt: { type: 'string', format: 'date-time' },
            errorCode: { type: 'string', maxLength: 128 },
          },
        },
        response: {
          202: {
            type: 'object',
            required: ['data'],
            properties: {
              data: {
                type: 'object',
                required: ['eventId', 'accepted'],
                properties: {
                  eventId: { type: 'string' },
                  accepted: { type: 'boolean' },
                },
              },
            },
          },
        },
      },
    },
    async (request, reply) => {
      const event = options.playbackEventService.record(
        request.params.videoId,
        request.body,
      );
      return reply.status(202).send({
        data: { eventId: event.id, accepted: true },
      });
    },
  );
};

import type { FastifyPluginAsync } from 'fastify';

import type { ChannelService } from '../application/channel-service.js';

interface ChannelRouteOptions {
  readonly channelService: ChannelService;
}

export const channelRoutes: FastifyPluginAsync<ChannelRouteOptions> = async (
  app,
  options,
) => {
  app.get(
    '/',
    {
      schema: {
        tags: ['Channels'],
        summary: 'List home channels',
        response: {
          200: {
            type: 'object',
            required: ['data'],
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  required: ['id', 'label', 'sortOrder', 'showsBadge'],
                  properties: {
                    id: { type: 'string' },
                    label: { type: 'string' },
                    sortOrder: { type: 'integer' },
                    showsBadge: { type: 'boolean' },
                  },
                },
              },
            },
          },
        },
      },
    },
    async () => ({ data: options.channelService.list() }),
  );
};

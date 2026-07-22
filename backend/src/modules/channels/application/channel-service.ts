import type { Channel } from '../domain/channel.js';

export class ChannelService {
  private readonly channelIds: ReadonlySet<string>;

  constructor(private readonly channels: readonly Channel[]) {
    this.channelIds = new Set(channels.map((channel) => channel.id));
  }

  list(): readonly Channel[] {
    return this.channels;
  }

  exists(channelId: string): boolean {
    return this.channelIds.has(channelId);
  }
}

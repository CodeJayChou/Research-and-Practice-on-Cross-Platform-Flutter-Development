import type { PlaybackEvent } from '../domain/playback-event.js';

export interface PlaybackEventRepository {
  append(event: PlaybackEvent): void;
}

export class InMemoryPlaybackEventRepository
  implements PlaybackEventRepository
{
  private readonly events: PlaybackEvent[] = [];

  constructor(private readonly capacity = 1000) {
    if (!Number.isInteger(capacity) || capacity < 1) {
      throw new Error('Playback event capacity must be a positive integer');
    }
  }

  append(event: PlaybackEvent): void {
    this.events.push(event);
    if (this.events.length > this.capacity) {
      this.events.splice(0, this.events.length - this.capacity);
    }
  }
}

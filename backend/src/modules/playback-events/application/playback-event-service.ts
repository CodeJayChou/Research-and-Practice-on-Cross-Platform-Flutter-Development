import { randomUUID } from 'node:crypto';

import type { VideoService } from '../../videos/application/video-service.js';
import type {
  PlaybackEvent,
  PlaybackEventInput,
} from '../domain/playback-event.js';
import type { PlaybackEventRepository } from '../infrastructure/in-memory-playback-event-repository.js';

export class PlaybackEventService {
  constructor(
    private readonly videoService: VideoService,
    private readonly eventRepository: PlaybackEventRepository,
  ) {}

  record(videoId: string, input: PlaybackEventInput): PlaybackEvent {
    this.videoService.getById(videoId);

    const event: PlaybackEvent = {
      ...input,
      id: randomUUID(),
      videoId,
      receivedAt: new Date().toISOString(),
    };
    this.eventRepository.append(event);
    return event;
  }
}

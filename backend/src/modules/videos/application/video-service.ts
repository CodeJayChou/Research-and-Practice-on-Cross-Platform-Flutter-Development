import { AppError } from '../../../common/errors/app-error.js';
import type { ChannelService } from '../../channels/application/channel-service.js';
import type { Video } from '../domain/video.js';
import type { VideoRepository } from '../infrastructure/in-memory-video-repository.js';

interface CursorPayload {
  readonly version: 1;
  readonly channelId: string;
  readonly offset: number;
}

export interface VideoPage {
  readonly data: readonly Video[];
  readonly pagination: {
    readonly nextCursor: string | null;
    readonly hasMore: boolean;
  };
}

export class VideoService {
  constructor(
    private readonly channelService: ChannelService,
    private readonly videoRepository: VideoRepository,
  ) {}

  listByChannel(
    channelId: string,
    cursor: string | undefined,
    limit: number,
  ): VideoPage {
    if (!this.channelService.exists(channelId)) {
      throw new AppError(404, 'CHANNEL_NOT_FOUND', 'Channel was not found');
    }

    const offset = cursor === undefined ? 0 : decodeCursor(cursor, channelId);
    const slice = this.videoRepository.listByChannel(channelId, offset, limit);
    const nextOffset = offset + slice.items.length;
    const hasMore = nextOffset < slice.total;

    return {
      data: slice.items,
      pagination: {
        nextCursor: hasMore ? encodeCursor(channelId, nextOffset) : null,
        hasMore,
      },
    };
  }

  getById(videoId: string): Video {
    const video = this.videoRepository.findById(videoId);
    if (video === undefined) {
      throw new AppError(404, 'VIDEO_NOT_FOUND', 'Video was not found');
    }
    return video;
  }
}

function encodeCursor(channelId: string, offset: number): string {
  const payload: CursorPayload = { version: 1, channelId, offset };
  return Buffer.from(JSON.stringify(payload), 'utf8').toString('base64url');
}

function decodeCursor(cursor: string, expectedChannelId: string): number {
  try {
    const decoded = Buffer.from(cursor, 'base64url').toString('utf8');
    const payload = JSON.parse(decoded) as Partial<CursorPayload>;

    if (
      payload.version !== 1 ||
      payload.channelId !== expectedChannelId ||
      !Number.isInteger(payload.offset) ||
      (payload.offset ?? -1) < 0
    ) {
      throw new Error('Cursor payload is invalid');
    }

    return payload.offset as number;
  } catch {
    throw new AppError(400, 'INVALID_CURSOR', 'Pagination cursor is invalid');
  }
}

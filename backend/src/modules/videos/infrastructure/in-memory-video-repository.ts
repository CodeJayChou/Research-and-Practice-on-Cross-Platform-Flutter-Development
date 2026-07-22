import type { Video } from '../domain/video.js';

export interface VideoSlice {
  readonly items: readonly Video[];
  readonly total: number;
}

export interface VideoRepository {
  findById(videoId: string): Video | undefined;
  listByChannel(channelId: string, offset: number, limit: number): VideoSlice;
}

export class InMemoryVideoRepository implements VideoRepository {
  private readonly videosById: ReadonlyMap<string, Video>;
  private readonly videosByChannel: ReadonlyMap<string, readonly Video[]>;

  constructor(videos: readonly Video[]) {
    this.videosById = new Map(videos.map((video) => [video.id, video]));

    const groupedVideos = new Map<string, Video[]>();
    for (const video of videos) {
      const channelVideos = groupedVideos.get(video.channelId) ?? [];
      channelVideos.push(video);
      groupedVideos.set(video.channelId, channelVideos);
    }
    this.videosByChannel = groupedVideos;
  }

  findById(videoId: string): Video | undefined {
    return this.videosById.get(videoId);
  }

  listByChannel(channelId: string, offset: number, limit: number): VideoSlice {
    const videos = this.videosByChannel.get(channelId) ?? [];
    return {
      items: videos.slice(offset, offset + limit),
      total: videos.length,
    };
  }
}

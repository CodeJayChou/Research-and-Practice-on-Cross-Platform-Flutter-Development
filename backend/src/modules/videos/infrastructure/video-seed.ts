import type { Channel } from '../../channels/domain/channel.js';
import type { Video } from '../domain/video.js';

const videoSources = [
  {
    url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    durationMs: 7800,
  },
  {
    url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    durationMs: 15000,
  },
  {
    url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    durationMs: 15000,
  },
] as const;

export function createVideoSeed(channels: readonly Channel[]): readonly Video[] {
  return channels.flatMap((channel, channelIndex) =>
    Array.from({ length: 8 }, (_, itemIndex) => {
      const source = videoSources[(channelIndex + itemIndex) % videoSources.length];
      if (source === undefined) {
        throw new Error('Video seed source is missing');
      }

      const sequence = itemIndex + 1;
      return {
        id: `${channel.id}-video-${sequence}`,
        channelId: channel.id,
        title: `${channel.label}示例视频 ${sequence}`,
        description: `用于本地联调的${channel.label}频道视频数据。`,
        posterUrl: `https://picsum.photos/seed/${channel.id}-${sequence}/720/1280`,
        width: 720,
        height: 1280,
        durationMs: source.durationMs,
        playback: {
          url: source.url,
          type: 'progressive' as const,
          mimeType: 'video/mp4',
        },
        author: {
          id: `creator-${(channelIndex % 5) + 1}`,
          displayName: `创作者 ${(channelIndex % 5) + 1}`,
          avatarUrl: `https://picsum.photos/seed/creator-${(channelIndex % 5) + 1}/128/128`,
        },
        stats: {
          viewCount: 12000 + channelIndex * 1370 + itemIndex * 219,
          likeCount: 800 + channelIndex * 51 + itemIndex * 17,
          commentCount: 50 + channelIndex * 3 + itemIndex,
          shareCount: 20 + channelIndex * 2 + itemIndex,
        },
        createdAt: new Date(
          Date.UTC(2026, 6, 1 + ((channelIndex + itemIndex) % 20), 12),
        ).toISOString(),
      } satisfies Video;
    }),
  );
}

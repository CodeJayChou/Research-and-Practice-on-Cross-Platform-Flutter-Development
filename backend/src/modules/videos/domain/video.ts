export interface VideoAuthor {
  readonly id: string;
  readonly displayName: string;
  readonly avatarUrl: string;
}

export interface VideoPlaybackSource {
  readonly url: string;
  readonly type: 'progressive' | 'hls';
  readonly mimeType: string;
}

export interface VideoStats {
  readonly viewCount: number;
  readonly likeCount: number;
  readonly commentCount: number;
  readonly shareCount: number;
}

export interface Video {
  readonly id: string;
  readonly channelId: string;
  readonly title: string;
  readonly description: string;
  readonly posterUrl: string;
  readonly width: number;
  readonly height: number;
  readonly durationMs: number;
  readonly playback: VideoPlaybackSource;
  readonly author: VideoAuthor;
  readonly stats: VideoStats;
  readonly createdAt: string;
}

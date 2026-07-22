export const playbackEventTypes = [
  'started',
  'progress',
  'paused',
  'buffering',
  'completed',
  'error',
] as const;

export type PlaybackEventType = (typeof playbackEventTypes)[number];

export interface PlaybackEventInput {
  readonly sessionId: string;
  readonly type: PlaybackEventType;
  readonly positionMs: number;
  readonly durationMs?: number;
  readonly occurredAt?: string;
  readonly errorCode?: string;
}

export interface PlaybackEvent extends PlaybackEventInput {
  readonly id: string;
  readonly videoId: string;
  readonly receivedAt: string;
}

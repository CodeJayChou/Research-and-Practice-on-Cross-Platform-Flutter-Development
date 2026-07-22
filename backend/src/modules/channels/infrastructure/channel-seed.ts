import type { Channel } from '../domain/channel.js';

const channelDefinitions = [
  ['live', '直播'],
  ['featured', '精选'],
  ['friends', '朋友'],
  ['nearby', '同城'],
  ['groupBuy', '团购'],
  ['following', '关注'],
  ['hot', '热点'],
  ['shortDrama', '短剧'],
  ['food', '美食'],
  ['music', '音乐'],
  ['games', '游戏'],
  ['technology', '科技'],
  ['sports', '体育'],
  ['recommended', '推荐'],
] as const;

export const channels: readonly Channel[] = channelDefinitions.map(
  ([id, label], sortOrder) => ({
    id,
    label,
    sortOrder,
    showsBadge: id === 'hot',
  }),
);

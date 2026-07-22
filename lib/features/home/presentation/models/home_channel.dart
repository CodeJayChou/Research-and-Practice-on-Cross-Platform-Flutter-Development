enum HomeChannel {
  live('直播'),
  featured('精选'),
  friends('朋友'),
  nearby('同城'),
  groupBuy('团购'),
  following('关注'),
  hot('热点'),
  shortDrama('短剧'),
  food('美食'),
  music('音乐'),
  games('游戏'),
  technology('科技'),
  sports('体育'),
  recommended('推荐');

  const HomeChannel(this.label);

  final String label;

  bool get showsBadge => this == HomeChannel.hot;
}

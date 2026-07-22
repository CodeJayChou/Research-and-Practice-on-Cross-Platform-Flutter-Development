import 'package:flutter/material.dart';

import '../../../../core/utils/icon_utils.dart';
import '../models/home_channel.dart';

const _inactiveColor = Color(0xFFB8B5B3);

class HomeTopNavigationBar extends StatefulWidget {
  const HomeTopNavigationBar({
    required this.selectedChannel,
    required this.onChannelSelected,
    required this.onMenuTap,
    required this.onSearchTap,
    super.key,
  });

  final HomeChannel selectedChannel;
  final ValueChanged<HomeChannel> onChannelSelected;
  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;

  static const backgroundColor = Colors.transparent;
  static const _sideMenuAssetPath = 'assets/icons/home/sideMenue_action.svg';

  @override
  State<HomeTopNavigationBar> createState() => _HomeTopNavigationBarState();
}

class _HomeTopNavigationBarState extends State<HomeTopNavigationBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: HomeChannel.values.length,
      initialIndex: widget.selectedChannel.index,
      animationDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(HomeTopNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_tabController.index != widget.selectedChannel.index) {
      _tabController.animateTo(widget.selectedChannel.index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ColoredBox(
        color: HomeTopNavigationBar.backgroundColor,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavigationAction(
                semanticLabel: '菜单',
                onTap: widget.onMenuTap,
                child: IconUtils.svgAsset(
                  assetPath: HomeTopNavigationBar._sideMenuAssetPath,
                  size: 24,
                  color: _inactiveColor,
                ),
              ),
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  labelColor: Colors.white,
                  unselectedLabelColor: _inactiveColor,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    insets: EdgeInsets.only(left: 3, right: 3, bottom: 7),
                  ),
                  dividerColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  splashFactory: NoSplash.splashFactory,
                  enableFeedback: false,
                  onTap: (index) {
                    widget.onChannelSelected(HomeChannel.values[index]);
                  },
                  tabs: HomeChannel.values.map((channel) {
                    return Tab(
                      height: 56,
                      child: _ChannelLabel(
                        key: ValueKey('home-channel-${channel.name}'),
                        channel: channel,
                      ),
                    );
                  }).toList(),
                ),
              ),
              _NavigationAction(
                semanticLabel: '搜索',
                onTap: widget.onSearchTap,
                child: const Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: _inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationAction extends StatelessWidget {
  const _NavigationAction({
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(width: 40, height: 56, child: Center(child: child)),
      ),
    );
  }
}

class _ChannelLabel extends StatelessWidget {
  const _ChannelLabel({required this.channel, super.key});

  final HomeChannel channel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Text(channel.label),
        if (channel.showsBadge)
          const Positioned(
            top: -3,
            right: -5,
            child: DecoratedBox(
              key: ValueKey('home-hot-badge'),
              decoration: BoxDecoration(
                color: Color(0xFFFF2D55),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 5),
            ),
          ),
      ],
    );
  }
}

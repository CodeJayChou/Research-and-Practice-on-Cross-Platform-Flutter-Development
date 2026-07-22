import 'package:flutter/material.dart';

import '../../../../core/widgets/layout/app_page_layout.dart';
import '../models/home_channel.dart';
import 'home_top_navigation_bar.dart';

typedef HomeChannelContentBuilder =
    Widget Function(BuildContext context, HomeChannel channel);

class HomeVideoView extends StatefulWidget {
  const HomeVideoView({
    required this.selectedChannel,
    required this.onChannelSelected,
    required this.onMenuTap,
    required this.onSearchTap,
    this.channelContentBuilder,
    super.key,
  });

  final HomeChannel selectedChannel;
  final ValueChanged<HomeChannel> onChannelSelected;
  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;
  final HomeChannelContentBuilder? channelContentBuilder;

  @override
  State<HomeVideoView> createState() => _HomeVideoViewState();
}

class _HomeVideoViewState extends State<HomeVideoView> {
  static const _pageTransitionDuration = Duration(milliseconds: 220);

  late final PageController _pageController;
  int? _programmaticTargetPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedChannel.index);
  }

  @override
  void didUpdateWidget(covariant HomeVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedChannel == widget.selectedChannel ||
        !_pageController.hasClients) {
      return;
    }

    final currentPage = _pageController.page?.round();
    if (currentPage == widget.selectedChannel.index) {
      return;
    }

    if (MediaQuery.disableAnimationsOf(context)) {
      _pageController.jumpToPage(widget.selectedChannel.index);
      return;
    }

    final targetPage = widget.selectedChannel.index;
    _programmaticTargetPage = targetPage;
    _pageController
        .animateToPage(
          targetPage,
          duration: _pageTransitionDuration,
          curve: Curves.easeOutCubic,
        )
        .whenComplete(() {
          if (_programmaticTargetPage == targetPage) {
            _programmaticTargetPage = null;
          }
        });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageLayout(
      mode: AppPageLayoutMode.immersive,
      backgroundColor: Colors.black,
      topBar: HomeTopNavigationBar(
        selectedChannel: widget.selectedChannel,
        onChannelSelected: widget.onChannelSelected,
        onMenuTap: widget.onMenuTap,
        onSearchTap: widget.onSearchTap,
      ),
      body: RepaintBoundary(
        key: const ValueKey('home-video-surface'),
        child: PageView.builder(
          key: const ValueKey('home-video-pager'),
          controller: _pageController,
          physics: const PageScrollPhysics(),
          itemCount: HomeChannel.values.length,
          onPageChanged: (index) {
            if (_programmaticTargetPage != null) {
              return;
            }

            final channel = HomeChannel.values[index];
            if (channel != widget.selectedChannel) {
              widget.onChannelSelected(channel);
            }
          },
          itemBuilder: (context, index) {
            final channel = HomeChannel.values[index];
            final channelContent = widget.channelContentBuilder?.call(
              context,
              channel,
            );

            return RepaintBoundary(
              key: ValueKey('home-channel-content-${channel.name}'),
              child:
                  channelContent ?? _HomeChannelPlaceholder(channel: channel),
            );
          },
        ),
      ),
    );
  }
}

class _HomeChannelPlaceholder extends StatelessWidget {
  const _HomeChannelPlaceholder({required this.channel});

  final HomeChannel channel;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Text(
          '${channel.label}频道内容',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}

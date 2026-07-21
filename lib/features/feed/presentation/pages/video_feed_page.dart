import 'package:flutter/material.dart';

import '../../data/repositories/mock_video_feed_repository.dart';
import '../controllers/video_feed_controller.dart';
import '../widgets/video_post_view.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({super.key});

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  late final VideoFeedController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoFeedController(const MockVideoFeedRepository())
      ..addListener(_onFeedChanged)
      ..load();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onFeedChanged)
      ..dispose();
    super.dispose();
  }

  void _onFeedChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [_buildContent(), const _FeedHeader()],
    );
  }

  Widget _buildContent() {
    return switch (_controller.status) {
      VideoFeedStatus.initial || VideoFeedStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      VideoFeedStatus.empty => const _FeedMessage(
        icon: Icons.video_library_outlined,
        message: '暂时没有推荐视频',
      ),
      VideoFeedStatus.failure => _FeedMessage(
        icon: Icons.cloud_off_outlined,
        message: '加载失败，点击重试',
        onTap: _controller.load,
      ),
      VideoFeedStatus.loaded => PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controller.posts.length,
        itemBuilder: (context, index) {
          final post = _controller.posts[index];
          return VideoPostView(
            post: post,
            paletteIndex: index,
            onLike: () => _controller.toggleLike(post.id),
          );
        },
      ),
    };
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '关注',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white60),
              ),
              const SizedBox(width: 24),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '推荐',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(width: 20, height: 2, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedMessage extends StatelessWidget {
  const _FeedMessage({required this.icon, required this.message, this.onTap});

  final IconData icon;
  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(message),
      ),
    );
  }
}

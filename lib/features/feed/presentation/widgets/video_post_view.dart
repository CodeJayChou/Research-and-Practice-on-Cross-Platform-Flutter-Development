import 'package:flutter/material.dart';

import '../../domain/entities/video_post.dart';

class VideoPostView extends StatelessWidget {
  const VideoPostView({
    required this.post,
    required this.paletteIndex,
    required this.onLike,
    super.key,
  });

  final VideoPost post;
  final int paletteIndex;
  final VoidCallback onLike;

  static const _palettes = [
    [Color(0xFF17203A), Color(0xFF5B2333)],
    [Color(0xFF133A35), Color(0xFF3E245B)],
    [Color(0xFF432818), Color(0xFF1B263B)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _palettes[paletteIndex % _palettes.length];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Center(
            child: Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.white24,
              size: 88,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 80, 12, 92),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _PostMetadata(post: post)),
                  const SizedBox(width: 12),
                  _PostActions(post: post, onLike: onLike),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostMetadata extends StatelessWidget {
  const _PostMetadata({required this.post});

  final VideoPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@${post.authorName}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Text(post.caption, maxLines: 3, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.music_note_rounded, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                post.soundtrack,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions({required this.post, required this.onLike});

  final VideoPost post;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person_rounded, color: Colors.white),
        ),
        const SizedBox(height: 20),
        _ActionButton(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          color: post.isLiked ? const Color(0xFFFF2C55) : Colors.white,
          label: _compactCount(post.likeCount),
          onTap: onLike,
        ),
        const SizedBox(height: 16),
        _ActionButton(
          icon: Icons.chat_bubble_rounded,
          label: _compactCount(post.commentCount),
        ),
        const SizedBox(height: 16),
        _ActionButton(
          icon: Icons.reply_rounded,
          label: _compactCount(post.shareCount),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.color = Colors.white,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

String _compactCount(int value) {
  if (value < 10000) return '$value';
  final count = value / 10000;
  return '${count.toStringAsFixed(count >= 100 ? 0 : 1)}万';
}

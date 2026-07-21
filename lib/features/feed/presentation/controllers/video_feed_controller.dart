import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../domain/entities/video_post.dart';
import '../../domain/repositories/video_feed_repository.dart';

enum VideoFeedStatus { initial, loading, loaded, empty, failure }

class VideoFeedController extends ChangeNotifier {
  VideoFeedController(this._repository);

  final VideoFeedRepository _repository;
  final List<VideoPost> _posts = [];
  bool _isDisposed = false;

  VideoFeedStatus status = VideoFeedStatus.initial;
  Object? error;

  UnmodifiableListView<VideoPost> get posts => UnmodifiableListView(_posts);

  Future<void> load() async {
    if (status == VideoFeedStatus.loading) return;

    status = VideoFeedStatus.loading;
    error = null;
    notifyListeners();

    try {
      final posts = await _repository.loadInitialFeed();
      if (_isDisposed) return;
      _posts
        ..clear()
        ..addAll(posts);
      status = _posts.isEmpty ? VideoFeedStatus.empty : VideoFeedStatus.loaded;
    } catch (exception) {
      if (_isDisposed) return;
      error = exception;
      status = VideoFeedStatus.failure;
    }

    notifyListeners();
  }

  void toggleLike(String postId) {
    if (_isDisposed) return;
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final isLiked = !post.isLiked;
    _posts[index] = post.copyWith(
      isLiked: isLiked,
      likeCount: post.likeCount + (isLiked ? 1 : -1),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

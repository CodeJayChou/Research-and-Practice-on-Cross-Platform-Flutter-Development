import '../entities/video_post.dart';

abstract interface class VideoFeedRepository {
  Future<List<VideoPost>> loadInitialFeed();
}

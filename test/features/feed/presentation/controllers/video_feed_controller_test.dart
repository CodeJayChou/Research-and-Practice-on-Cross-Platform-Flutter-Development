import 'package:cross_platform_app/features/feed/domain/entities/video_post.dart';
import 'package:cross_platform_app/features/feed/domain/repositories/video_feed_repository.dart';
import 'package:cross_platform_app/features/feed/presentation/controllers/video_feed_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads posts and toggles the like state', () async {
    final controller = VideoFeedController(_FakeVideoFeedRepository());

    await controller.load();
    expect(controller.status, VideoFeedStatus.loaded);
    expect(controller.posts, hasLength(1));

    controller.toggleLike('post-1');
    expect(controller.posts.single.isLiked, isTrue);
    expect(controller.posts.single.likeCount, 11);
  });
}

class _FakeVideoFeedRepository implements VideoFeedRepository {
  @override
  Future<List<VideoPost>> loadInitialFeed() async {
    return [
      VideoPost(
        id: 'post-1',
        authorName: 'tester',
        caption: 'caption',
        soundtrack: 'soundtrack',
        videoUrl: Uri.parse('https://example.com/video.mp4'),
        likeCount: 10,
        commentCount: 2,
        shareCount: 1,
      ),
    ];
  }
}

import '../../domain/entities/video_post.dart';
import '../../domain/repositories/video_feed_repository.dart';

class MockVideoFeedRepository implements VideoFeedRepository {
  const MockVideoFeedRepository();

  @override
  Future<List<VideoPost>> loadInitialFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    return [
      VideoPost(
        id: 'city-night',
        authorName: '城市漫游者',
        caption: '下班后，去看看城市另一面的光。 #城市夜景 #生活记录',
        soundtrack: '原声 · 城市漫游者',
        videoUrl: Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ),
        likeCount: 1284000,
        commentCount: 36200,
        shareCount: 15800,
      ),
      VideoPost(
        id: 'weekend-coffee',
        authorName: '一杯周末',
        caption: '慢一点，周末应该留给咖啡和阳光。 #治愈 #周末',
        soundtrack: '轻松一刻 · 一杯周末',
        videoUrl: Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        ),
        likeCount: 892000,
        commentCount: 18900,
        shareCount: 9700,
      ),
      VideoPost(
        id: 'mountain-wind',
        authorName: '追风的人',
        caption: '山顶的风会记住每一次出发。 #旅行 #户外',
        soundtrack: '向远方 · 追风的人',
        videoUrl: Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ),
        likeCount: 476000,
        commentCount: 12300,
        shareCount: 8200,
      ),
    ];
  }
}

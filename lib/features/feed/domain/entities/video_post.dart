class VideoPost {
  const VideoPost({
    required this.id,
    required this.authorName,
    required this.caption,
    required this.soundtrack,
    required this.videoUrl,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.isLiked = false,
  });

  final String id;
  final String authorName;
  final String caption;
  final String soundtrack;
  final Uri videoUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;

  VideoPost copyWith({int? likeCount, bool? isLiked}) {
    return VideoPost(
      id: id,
      authorName: authorName,
      caption: caption,
      soundtrack: soundtrack,
      videoUrl: videoUrl,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      shareCount: shareCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

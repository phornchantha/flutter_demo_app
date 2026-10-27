class VideoModel {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String views;
  final String likes;
  final int commentsCount;
  final String creatorName;
  final String creatorBio;
  final String? creatorAvatar;
  final String category;
  final String? linkedMealId;

  VideoModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.duration,
    required this.views,
    required this.likes,
    required this.commentsCount,
    required this.creatorName,
    this.creatorBio = 'Khmer home cooking',
    this.creatorAvatar,
    this.category = 'For you',
    this.linkedMealId,
  });
}

class CommentModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String timestamp;
  final String text;
  final bool isOwner;

  CommentModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.timestamp,
    required this.text,
    this.isOwner = false,
  });
}

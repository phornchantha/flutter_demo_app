class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int videosCount;
  final int followersCount;
  final int followingCount;
  final String bio;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.videosCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.bio = 'Cooking enthusiast',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'videosCount': videosCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'bio': bio,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      videosCount: json['videosCount'] as int? ?? 0,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      bio: json['bio'] as String? ?? 'Cooking enthusiast',
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../videos/video_player_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userName;
  final String userBio;

  const UserProfileScreen({
    Key? key,
    this.userName = 'Dara',
    this.userBio = 'Khmer home cooking',
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;

  final List<Map<String, dynamic>> _userVideos = [
    {'title': 'Perfect pancakes', 'color': AppTheme.brandGoldBackground},
    {'title': 'Fried rice', 'color': const Color(0xFF064E3B)},
    {'title': 'Curry basics', 'color': const Color(0xFF312E81)},
    {'title': 'Soup masterclass', 'color': const Color(0xFF451A03)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Avatar Circle
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'D',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Name & Bio
            Text(
              widget.userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.userBio,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Stats Row: 24 Videos | 3.4k Followers | 180 Following
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '24',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Videos',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '3.4k',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Followers',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '180',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Following',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // White Pill Action Button: Follow
            SizedBox(
              width: 160,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFollowing ? AppTheme.darkInputFill : Colors.white,
                  foregroundColor: _isFollowing ? Colors.white : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isFollowing = !_isFollowing;
                  });
                },
                child: Text(
                  _isFollowing ? 'Following' : 'Follow',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Videos Grid Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Videos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2x2 Grid of Videos
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _userVideos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final vid = _userVideos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                          videoTitle: vid['title'] as String,
                          creatorName: widget.userName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: vid['color'] as Color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.darkBorderColor.withOpacity(0.5)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

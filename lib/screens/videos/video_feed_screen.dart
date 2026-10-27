import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/models/video_model.dart';
import '../../providers/auth_provider.dart';
import 'upload_video_screen.dart';
import 'video_player_screen.dart';

class VideoFeedScreen extends ConsumerStatefulWidget {
  const VideoFeedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends ConsumerState<VideoFeedScreen> {
  String _selectedTab = 'For you';

  final List<VideoModel> _videos = [
    VideoModel(
      id: 'v1',
      title: 'Perfect pancakes',
      duration: '8:24',
      views: '12k',
      likes: '1.2k',
      commentsCount: 86,
      creatorName: 'Dara',
      creatorBio: 'Khmer home cooking',
      creatorAvatar: 'D',
    ),
    VideoModel(
      id: 'v2',
      title: 'Fried rice in 10 min',
      duration: '5:10',
      views: '8k',
      likes: '850',
      commentsCount: 42,
      creatorName: 'Mey',
      creatorBio: 'Quick & easy meals',
      creatorAvatar: 'M',
    ),
    VideoModel(
      id: 'v3',
      title: 'Curry basics',
      duration: '12:05',
      views: '24k',
      likes: '3.1k',
      commentsCount: 120,
      creatorName: 'Sokha',
      creatorBio: 'Authentic flavors',
      creatorAvatar: 'S',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final tabs = ['For you', 'Following', 'Quick'];

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text(
          'Videos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips (For you, Following, Quick)
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = _selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      tab,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTab = tab;
                      });
                    },
                    backgroundColor: AppTheme.darkInputFill,
                    selectedColor: AppTheme.primaryBlue,
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.darkBorderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Video Feed List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                          videoTitle: video.title,
                          creatorName: video.creatorName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video Card Viewport
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? AppTheme.brandGoldBackground
                                : const Color(0xFF064E3B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.darkBorderColor.withOpacity(0.5)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.play_arrow_rounded,
                                size: 56,
                                color: AppTheme.brandGold,
                              ),
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    video.duration,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title & Creator Bar
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryBlue,
                              child: Text(
                                video.creatorAvatar ?? 'D',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${video.creatorName} · ${video.views} views',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button + (Upload Video)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadVideoScreen()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

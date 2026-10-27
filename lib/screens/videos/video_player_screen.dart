import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/models/meal.dart';
import '../../providers/shopping_list_provider.dart';
import '../meal_detail/meal_detail_screen.dart';
import '../profile/user_profile_screen.dart';
import 'comments_bottom_sheet.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String videoTitle;
  final String creatorName;
  final Meal? meal;

  const VideoPlayerScreen({
    super.key,
    required this.videoTitle,
    required this.creatorName,
    this.meal,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  bool _isFollowing = false;
  bool _isLiked = false;
  bool _isSaved = false;
  int _likesCount = 1200;

  @override
  Widget build(BuildContext context) {
    // Default meal if none passed
    final linkedMeal = widget.meal ??
        Meal(
          id: '52893',
          name: widget.videoTitle.replaceAll('Perfect ', '').replaceAll('Fried ', ''),
          category: 'Breakfast',
          area: 'International',
          instructions: 'Whisk dry ingredients. Add milk and eggs. Cook on skillet.',
          thumbnail: '',
          ingredients: ['flour', 'milk', 'eggs'],
          measures: ['200 g', '300 ml', '2'],
        );

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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Viewport Player Card
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF3D2005),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.brandGold.withValues(alpha: 0.3)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.play_arrow_rounded,
                    size: 64,
                    color: AppTheme.brandGold,
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const LinearProgressIndicator(
                        value: 0.35,
                        backgroundColor: AppTheme.darkBorderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                        minHeight: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Video Title
            Text(
              widget.videoTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Creator Bar: Avatar, Name, Follow Button
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                          userName: widget.creatorName,
                          userBio: 'Khmer home cooking',
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryBlue,
                        child: Text(
                          widget.creatorName.isNotEmpty ? widget.creatorName[0].toUpperCase() : 'D',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.creatorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFollowing ? AppTheme.darkInputFill : Colors.white,
                    foregroundColor: _isFollowing ? Colors.white : Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isFollowing = !_isFollowing;
                    });
                  },
                  child: Text(
                    _isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Social Action Bar: 👍 1.2k | 💬 86 | 🔖 Save | 🚩 Report
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likesCount += _isLiked ? 1 : -1;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: _isLiked ? AppTheme.primaryBlue : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${(_likesCount / 1000).toStringAsFixed(1)}k',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CommentsBottomSheet(videoTitle: widget.videoTitle),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        '86',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isSaved ? 'Video saved!' : 'Video removed from saved'),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_outline_rounded,
                        color: _isSaved ? AppTheme.brandGold : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Save',
                        style: TextStyle(
                          color: _isSaved ? AppTheme.brandGold : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report submitted')),
                    );
                  },
                  child: const Icon(Icons.outlined_flag_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Banner Card: Full Recipe (Ingredients and steps) >
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealDetailScreen(meal: linkedMeal),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppTheme.darkCardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.darkBorderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.brandGoldBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.soup_kitchen_rounded,
                        color: AppTheme.brandGold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Full recipe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Ingredients and steps',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Primary Blue Button: Add ingredients to shopping list
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text(
                  'Add ingredients to shopping list',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  ref.read(shoppingListProvider.notifier).addIngredients(
                        recipeName: linkedMeal.name,
                        ingredients: linkedMeal.ingredients.isNotEmpty
                            ? linkedMeal.ingredients
                            : ['flour', 'milk', 'eggs'],
                        measures: linkedMeal.measures.isNotEmpty
                            ? linkedMeal.measures
                            : ['200 g', '300 ml', '2'],
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ingredients for ${linkedMeal.name} to Shopping List!'),
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

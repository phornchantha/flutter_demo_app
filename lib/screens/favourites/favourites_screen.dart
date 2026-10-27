import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/favorites_provider.dart';
import '../meal_detail/meal_detail_screen.dart';
import '../videos/video_player_screen.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  int _selectedSegment = 0; // 0 = Recipes, 1 = Videos

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text(
          'Saved',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Toggles: [ Recipes | Videos ]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Recipes'),
                  selected: _selectedSegment == 0,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSegment = 0);
                  },
                  selectedColor: AppTheme.primaryBlue,
                  backgroundColor: AppTheme.darkInputFill,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: _selectedSegment == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: _selectedSegment == 0 ? AppTheme.primaryBlue : AppTheme.darkBorderColor,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Videos'),
                  selected: _selectedSegment == 1,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSegment = 1);
                  },
                  selectedColor: AppTheme.primaryBlue,
                  backgroundColor: AppTheme.darkInputFill,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: _selectedSegment == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: _selectedSegment == 1 ? AppTheme.primaryBlue : AppTheme.darkBorderColor,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Content List
          Expanded(
            child: _selectedSegment == 0
                ? _buildSavedRecipes(favoritesAsync)
                : _buildSavedVideos(),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedRecipes(AsyncValue favoritesAsync) {
    return favoritesAsync.when(
      data: (meals) {
        if (meals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: AppTheme.textSecondary),
                SizedBox(height: 16),
                Text(
                  'No saved recipes yet',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppTheme.darkCardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.darkBorderColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    // Icon/Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 52,
                        height: 52,
                        color: AppTheme.brandGoldBackground,
                        child: meal.thumbnail.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: meal.thumbnail,
                                httpHeaders: AppConstants.getHeadersForUrl(meal.thumbnail),
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.soup_kitchen_rounded,
                                  color: AppTheme.brandGold,
                                  size: 26,
                                ),
                              )
                            : const Icon(
                                Icons.soup_kitchen_rounded,
                                color: AppTheme.brandGold,
                                size: 26,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Meal Name & Tag
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${meal.category.isNotEmpty ? meal.category : 'Breakfast'} · 20 min',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Favorite Heart Toggle
                    IconButton(
                      icon: const Icon(Icons.favorite, color: AppTheme.errorRed),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggle(meal);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandGold)),
      error: (_, __) => const Center(
        child: Text('Failed to load saved recipes', style: TextStyle(color: AppTheme.errorRed)),
      ),
    );
  }

  Widget _buildSavedVideos() {
    final mockSavedVideos = [
      {
        'title': 'Perfect pancakes',
        'creator': 'Dara',
        'subtitle': 'Breakfast · 20 min',
        'color': AppTheme.brandGoldBackground,
      },
      {
        'title': 'Chicken curry',
        'creator': 'Mey',
        'subtitle': 'Dinner · 40 min',
        'color': const Color(0xFF451A03),
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: mockSavedVideos.length,
      itemBuilder: (context, index) {
        final video = mockSavedVideos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayerScreen(
                  videoTitle: video['title'] as String,
                  creatorName: video['creator'] as String,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppTheme.darkCardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.darkBorderColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: video['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppTheme.brandGold,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video['subtitle'] as String,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.favorite, color: AppTheme.errorRed),
              ],
            ),
          ),
        );
      },
    );
  }
}

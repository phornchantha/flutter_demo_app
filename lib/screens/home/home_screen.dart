import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/meals_provider.dart';
import '../meal_detail/meal_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final allMealsAsync = ref.watch(allMealsProvider);
    final favorites = ref.watch(favoritesProvider).value ?? [];

    final categories = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Seafood', 'Chicken', 'Vegetarian'];

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text(
          'Recipes',
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
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim().toLowerCase();
                  if (_searchQuery.isNotEmpty) {
                    _selectedCategory = 'All';
                  }
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search recipes',
                hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                fillColor: AppTheme.darkInputFill,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.darkBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.darkBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.brandGold),
                ),
              ),
            ),
          ),

          // Category Chips Row
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppTheme.darkInputFill,
                    selectedColor: AppTheme.primaryBlue,
                    checkmarkColor: Colors.white,
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

          // Meal List
          Expanded(
            child: allMealsAsync.when(
              data: (meals) {
                // Filter meals by category and search query
                var filtered = meals.where((m) {
                  final matchesCat = _selectedCategory == 'All' ||
                      m.category.toLowerCase().contains(_selectedCategory.toLowerCase());
                  final matchesSearch = _searchQuery.isEmpty ||
                      m.name.toLowerCase().contains(_searchQuery) ||
                      m.category.toLowerCase().contains(_searchQuery);
                  return matchesCat && matchesSearch;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final meal = filtered[index];
                    final isFav = favorites.any((f) => f.id == meal.id);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailScreen(meal: meal),
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
                            // Thumbnail / Badge
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 56,
                                height: 56,
                                color: AppTheme.brandGoldBackground,
                                child: meal.thumbnail.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: meal.thumbnail,
                                        httpHeaders: AppConstants.getHeadersForUrl(meal.thumbnail),
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) => const Icon(
                                          Icons.soup_kitchen_rounded,
                                          color: AppTheme.brandGold,
                                          size: 28,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.soup_kitchen_rounded,
                                        color: AppTheme.brandGold,
                                        size: 28,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Meal Name & Category / Time
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

                            // Heart / Favorite Toggle
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? AppTheme.errorRed : AppTheme.textSecondary,
                              ),
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
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.brandGold),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Failed to load recipes: $err',
                  style: const TextStyle(color: AppTheme.errorRed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

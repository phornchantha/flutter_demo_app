import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../meal_detail/meal_detail_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final mealsAsync = selectedCategory != null
        ? ref.watch(mealsByCategoryProvider(selectedCategory))
        : ref.watch(searchMealsProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Explore Recipes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  ref.read(selectedCategoryProvider.notifier).state = null;
                }
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.darkInputFill,
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.darkBorderColor),
                ),
              ),
            ),
          ),

          // Category Chips
          categoriesAsync.when(
            data: (categories) => Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category.name;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(category.name),
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedCategoryProvider.notifier).state = category.name;
                          ref.read(searchQueryProvider.notifier).state = '';
                        } else {
                          ref.read(selectedCategoryProvider.notifier).state = null;
                        }
                      },
                      selectedColor: AppTheme.primaryBlue,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: AppTheme.darkInputFill,
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.darkBorderColor,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                },
              ),
            ),
            loading: () => const SizedBox(height: 50),
            error: (_, __) => const SizedBox(height: 50),
          ),

          const SizedBox(height: 8),

          // Meals List
          Expanded(
            child: (searchQuery.isEmpty && selectedCategory == null)
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Search or select a category',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : mealsAsync.when(
                    data: (meals) {
                      if (meals.isEmpty) {
                        return const Center(
                          child: Text('No recipes found', style: TextStyle(color: AppTheme.textSecondary)),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          final meal = meals[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.darkCardSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.darkBorderColor),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: meal.thumbnail,
                                  httpHeaders: AppConstants.getHeadersForUrl(meal.thumbnail),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 60,
                                    height: 60,
                                    color: AppTheme.darkInputFill,
                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 60,
                                    height: 60,
                                    color: AppTheme.darkInputFill,
                                    child: const Icon(Icons.image, color: AppTheme.textSecondary),
                                  ),
                                ),
                              ),
                              title: Text(
                                meal.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              subtitle: Text(
                                '${meal.category} • ${meal.area}',
                                style: const TextStyle(color: AppTheme.textSecondary),
                              ),
                              trailing: const Icon(Icons.chevron_right, color: Colors.white),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MealDetailScreen(meal: meal),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.brandGold)),
                    error: (error, stackTrace) => Center(child: Text('Error: $error', style: const TextStyle(color: AppTheme.errorRed))),
                  ),
          ),
        ],
      ),
    );
  }
}

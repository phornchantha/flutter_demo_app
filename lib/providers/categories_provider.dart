import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/category.dart';
import '../data/models/meal.dart';
import '../data/services/api_service.dart';
import 'meals_provider.dart';

// Improved Categories Provider
// This now derives categories from the actual meals list to ensure 
// they are unique and correct food categories.
final categoriesProvider = FutureProvider<List<MealCategory>>((ref) async {
  try {
    // We always derive categories from the meals list because the 
    // /categories endpoint in this specific API often contains junk data.
    final allMeals = await ref.watch(allMealsProvider.future);
    
    // Get unique category names from the meal data
    final uniqueCategoryNames = allMeals.map((m) => m.category).toSet().toList();
    uniqueCategoryNames.sort(); // Sort alphabetically
    
    return uniqueCategoryNames.map((name) {
      return MealCategory(
        id: name,
        name: name,
        // Automatically assign a matching food icon based on the name
        thumbnail: MealCategory.getFallbackIcon(name), 
        description: 'Explore our delicious $name recipes.',
      );
    }).toList();
  } catch (e) {
    throw Exception('Failed to load categories: $e');
  }
});

// Selected category provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Category meals loading state
final categoryMealsLoadingProvider = StateProvider<bool>((ref) => false);

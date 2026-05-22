import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/meal.dart';
import '../data/repositories/meal_repository.dart';
import '../data/services/api_service.dart';

// API Service Provider
final apiServiceProvider = Provider((ref) => ApiService());

// Meal Repository Provider
final mealRepositoryProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MealRepository(apiService: apiService);
});

// All meals provider
final allMealsProvider = FutureProvider<List<Meal>>((ref) async {
  final repository = ref.watch(mealRepositoryProvider);
  return repository.getMeals();
});

// Meals by category provider
final mealsByCategoryProvider = FutureProvider.family<List<Meal>, String>((
  ref,
  categoryName,
) async {
  final repository = ref.watch(mealRepositoryProvider);
  return repository.getMealsByCategory(categoryName);
});

// Meal detail provider
final mealDetailProvider = FutureProvider.family<Meal?, String>((
  ref,
  mealId,
) async {
  final repository = ref.watch(mealRepositoryProvider);
  return repository.getMealDetails(mealId);
});

// Search meals provider
final searchMealsProvider = FutureProvider.family<List<Meal>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }
  final repository = ref.watch(mealRepositoryProvider);
  return repository.searchMeals(query);
});

// Random meal provider
final randomMealProvider = FutureProvider<Meal?>((ref) async {
  final repository = ref.watch(mealRepositoryProvider);
  return repository.getRandomMeal();
});

// Areas provider (derived from meals)
final areasProvider = FutureProvider<List<String>>((ref) async {
  final meals = await ref.watch(allMealsProvider.future);
  return meals.map((m) => m.area).toSet().toList();
});

// Search query state provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// --- NAVIGATION PROVIDER ---
final navigationIndexProvider = StateProvider<int>((ref) => 0);

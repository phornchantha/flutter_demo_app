import '../models/meal.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class MealRepository {
  final ApiService _api;

  MealRepository({ApiService? apiService}) : _api = apiService ?? ApiService();

  Future<List<Meal>> getMeals() => _api.getMeals();

  Future<List<MealCategory>> getCategories() => _api.getCategories();

  Future<List<Meal>> getMealsByCategory(String categoryName) =>
      _api.getMealsByCategory(categoryName);

  Future<Meal?> getMealDetails(String mealId) => _api.getMealById(mealId);

  Future<List<Meal>> searchMeals(String query) => _api.searchMealsByName(query);

  Future<Meal?> getRandomMeal() => _api.getRandomMeal();
}

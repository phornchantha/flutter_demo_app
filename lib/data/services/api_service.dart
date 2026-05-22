import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;
  final Map<String, String> headers = AppConstants.headers;
  final http.Client httpClient;

  ApiService({http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  // Get all meals
  Future<List<Meal>> getMeals() async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/meals'), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> mealsList = jsonData is List ? jsonData : (jsonData['meals'] ?? []);
        return mealsList
            .map((meal) => Meal.fromJson(meal as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meals: $e');
    }
  }

  // Get all categories
  Future<List<MealCategory>> getCategories() async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/categories'), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> categoriesList = jsonData is List ? jsonData : (jsonData['categories'] ?? []);
        return categoriesList
            .map((category) => MealCategory.fromJson(category as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get meals by category
  Future<List<Meal>> getMealsByCategory(String categoryName) async {
    try {
      final response = await httpClient
          .get(
            Uri.parse('$baseUrl/meals?category=$categoryName'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> mealsList = jsonData is List ? jsonData : (jsonData['meals'] ?? []);
        return mealsList
            .map((meal) => Meal.fromJson(meal as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meals: $e');
    }
  }

  // Get meal details by ID
  Future<Meal?> getMealById(String mealId) async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/meals/$mealId'), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('meals')) {
          final List<dynamic> meals = jsonData['meals'] ?? [];
          if (meals.isNotEmpty) {
            return Meal.fromJson(meals[0] as Map<String, dynamic>);
          }
        } else if (jsonData is Map<String, dynamic>) {
          return Meal.fromJson(jsonData);
        }
        return null;
      } else {
        throw Exception('Failed to load meal details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meal details: $e');
    }
  }

  // Search meals by name
  Future<List<Meal>> searchMealsByName(String mealName) async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/search?s=$mealName'), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> mealsList = jsonData is List ? jsonData : (jsonData['meals'] ?? []);
        return mealsList
            .map((meal) => Meal.fromJson(meal as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to search meals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching meals: $e');
    }
  }

  // Get random meal
  Future<Meal?> getRandomMeal() async {
    try {
      // First try the /random endpoint
      final response = await httpClient
          .get(Uri.parse('$baseUrl/random'), headers: headers)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> meals = jsonData is List ? jsonData : (jsonData['meals'] ?? []);
        if (meals.isNotEmpty) {
          return Meal.fromJson(meals[0] as Map<String, dynamic>);
        }
      }
      
      // If /random fails or returns nothing, fetch all meals and pick one
      final allMeals = await getMeals();
      if (allMeals.isNotEmpty) {
        allMeals.shuffle();
        return allMeals.first;
      }
      return null;
    } catch (e) {
      // Fallback if anything fails
      try {
        final allMeals = await getMeals();
        if (allMeals.isNotEmpty) {
          allMeals.shuffle();
          return allMeals.first;
        }
      } catch (_) {}
      return null;
    }
  }
}

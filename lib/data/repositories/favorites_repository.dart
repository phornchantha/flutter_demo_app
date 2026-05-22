import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../models/meal.dart';

class FavoritesRepository {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  // Get all favorites
  Future<List<Meal>> getFavorites() async {
    await _initialize();
    try {
      final List<String>? favoritesList = _prefs.getStringList(favoritesKey);
      if (favoritesList == null || favoritesList.isEmpty) {
        return [];
      }
      return favoritesList
          .map((meal) => Meal.fromJson(jsonDecode(meal)))
          .toList();
    } catch (e) {
      throw Exception('Error loading favorites: $e');
    }
  }

  // Add favorite
  Future<void> addFavorite(Meal meal) async {
    await _initialize();
    try {
      final List<String>? favoritesList =
          _prefs.getStringList(favoritesKey) ?? [];
      final mealJson = jsonEncode(meal.toJson());
      if (!favoritesList!.contains(mealJson)) {
        favoritesList.add(mealJson);
        await _prefs.setStringList(favoritesKey, favoritesList);
      }
    } catch (e) {
      throw Exception('Error adding favorite: $e');
    }
  }

  // Remove favorite
  Future<void> removeFavorite(String mealId) async {
    await _initialize();
    try {
      List<String>? favoritesList = _prefs.getStringList(favoritesKey);
      if (favoritesList != null) {
        favoritesList.removeWhere((meal) {
          final mealData = jsonDecode(meal);
          return mealData['idMeal'] == mealId;
        });
        await _prefs.setStringList(favoritesKey, favoritesList);
      }
    } catch (e) {
      throw Exception('Error removing favorite: $e');
    }
  }

  // Check if meal is favorite
  Future<bool> isFavorite(String mealId) async {
    await _initialize();
    try {
      final List<String>? favoritesList = _prefs.getStringList(favoritesKey);
      if (favoritesList == null || favoritesList.isEmpty) {
        return false;
      }
      return favoritesList.any((meal) {
        final mealData = jsonDecode(meal);
        return mealData['idMeal'] == mealId;
      });
    } catch (e) {
      return false;
    }
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    await _initialize();
    try {
      await _prefs.remove(favoritesKey);
    } catch (e) {
      throw Exception('Error clearing favorites: $e');
    }
  }
}

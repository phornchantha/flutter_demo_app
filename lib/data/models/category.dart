import '../../core/constants.dart';

class MealCategory {
  final String id;
  final String name;
  final String thumbnail;
  final String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    // --- 1. SMART NAME FINDER ---
    String catName = '';
    final nameKeys = ['strCategory', 'name', 'title', 'label', 'category', 'item', 'type'];
    for (var key in nameKeys) {
      if (json[key] != null && json[key].toString().trim().length > 1) {
        catName = json[key].toString().trim();
        break;
      }
    }
    if (catName.isEmpty) {
      for (var value in json.values) {
        if (value is String && value.length > 2 && value.length < 20 && !value.contains('http') && catName.isEmpty) {
          catName = value;
        }
      }
    }
    if (catName.isEmpty) catName = 'Category';

    // --- 2. SMART IMAGE FINDER ---
    String imageUrl = '';
    final imgKeys = ['strCategoryThumb', 'thumbnail', 'image', 'img', 'photo', 'url', 'pic', 'thumb'];
    for (var key in imgKeys) {
      final val = json[key]?.toString();
      if (val != null && val.contains('http')) {
        imageUrl = val;
        break;
      }
    }
    
    if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';
    if (imageUrl.startsWith('/') && !imageUrl.startsWith('//')) imageUrl = '${AppConstants.baseUrl}$imageUrl';
    
    if (imageUrl.isEmpty || imageUrl.contains('null')) {
      imageUrl = getFallbackIcon(catName);
    }

    return MealCategory(
      id: json['idCategory']?.toString() ?? json['id']?.toString() ?? catName,
      name: catName,
      thumbnail: imageUrl,
      description: json['strCategoryDescription']?.toString() ?? json['description']?.toString() ?? 'Explore $catName recipes',
    );
  }

  static String getFallbackIcon(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('beef')) return 'https://www.themealdb.com/images/category/beef.png';
    if (lower.contains('chicken')) return 'https://www.themealdb.com/images/category/chicken.png';
    if (lower.contains('dessert')) return 'https://www.themealdb.com/images/category/dessert.png';
    if (lower.contains('lamb')) return 'https://www.themealdb.com/images/category/lamb.png';
    if (lower.contains('pork')) return 'https://www.themealdb.com/images/category/pork.png';
    if (lower.contains('seafood') || lower.contains('sea')) return 'https://www.themealdb.com/images/category/seafood.png';
    if (lower.contains('pasta')) return 'https://www.themealdb.com/images/category/pasta.png';
    if (lower.contains('breakfast')) return 'https://www.themealdb.com/images/category/breakfast.png';
    if (lower.contains('vegetarian') || lower.contains('veg')) return 'https://www.themealdb.com/images/category/vegetarian.png';
    if (lower.contains('goat')) return 'https://www.themealdb.com/images/category/goat.png';
    if (lower.contains('starter')) return 'https://www.themealdb.com/images/category/starter.png';
    if (lower.contains('side')) return 'https://www.themealdb.com/images/category/side.png';
    return 'https://www.themealdb.com/images/category/miscellaneous.png';
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/meal.dart';
import '../data/repositories/favorites_repository.dart';

// Favorites Repository Provider
final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());

class FavoritesNotifier extends AsyncNotifier<List<Meal>> {
  @override
  Future<List<Meal>> build() async {
    final repository = ref.watch(favoritesRepositoryProvider);
    return repository.getFavorites();
  }

  Future<void> toggle(Meal meal) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final isFav = await repository.isFavorite(meal.id);
    if (isFav) {
      await repository.removeFavorite(meal.id);
    } else {
      await repository.addFavorite(meal);
    }
    // Refresh the state
    state = await AsyncValue.guard(() => repository.getFavorites());
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Meal>>(FavoritesNotifier.new);

// Check if meal is favorite
final isFavoriteProvider = Provider.family<bool, String>((ref, mealId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.maybeWhen(
    data: (meals) => meals.any((m) => m.id == mealId),
    orElse: () => false,
  );
});

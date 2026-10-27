import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingItem {
  final String id;
  final String name;
  final String measure;
  final String recipeName;
  final bool isChecked;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.measure,
    required this.recipeName,
    this.isChecked = false,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? measure,
    String? recipeName,
    bool? isChecked,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      measure: measure ?? this.measure,
      recipeName: recipeName ?? this.recipeName,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  ShoppingListNotifier() : super([]);

  void addIngredients({
    required String recipeName,
    required List<String> ingredients,
    required List<String> measures,
  }) {
    final newItems = <ShoppingItem>[];
    for (int i = 0; i < ingredients.length; i++) {
      final name = ingredients[i];
      if (name.trim().isEmpty) continue;
      final measure = i < measures.length ? measures[i] : '';
      newItems.add(
        ShoppingItem(
          id: '${recipeName}_${name}_${DateTime.now().millisecondsSinceEpoch}_$i',
          name: name,
          measure: measure,
          recipeName: recipeName,
        ),
      );
    }
    state = [...state, ...newItems];
  }

  void toggleCheck(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isChecked: !item.isChecked) else item
    ];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>((ref) {
  return ShoppingListNotifier();
});

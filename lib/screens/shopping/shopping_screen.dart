import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../providers/shopping_list_provider.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingList = ref.watch(shoppingListProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        title: const Text(
          'Shopping list',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (shoppingList.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(shoppingListProvider.notifier).clearAll();
              },
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: AppTheme.errorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: shoppingList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: AppTheme.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    'Your shopping list is empty',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add ingredients from any recipe or video!',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: shoppingList.length,
              itemBuilder: (context, index) {
                final item = shoppingList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCardSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.darkBorderColor.withOpacity(0.5)),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.isChecked,
                      activeColor: AppTheme.successGreen,
                      checkColor: Colors.white,
                      onChanged: (_) {
                        ref.read(shoppingListProvider.notifier).toggleCheck(item.id);
                      },
                    ),
                    title: Text(
                      '${item.measure} ${item.name}'.trim(),
                      style: TextStyle(
                        color: item.isChecked ? AppTheme.textSecondary : Colors.white,
                        decoration: item.isChecked ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      item.recipeName,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 18),
                      onPressed: () {
                        ref.read(shoppingListProvider.notifier).removeItem(item.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

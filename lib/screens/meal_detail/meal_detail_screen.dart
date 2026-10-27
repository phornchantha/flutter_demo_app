import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/meal.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/shopping_list_provider.dart';
import '../videos/video_player_screen.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  int _servings = 4;
  late Set<int> _completedSteps;

  @override
  void initState() {
    super.initState();
    _completedSteps = {};
  }

  // Parse measure string and scale quantity according to servings (base = 4 servings)
  String _getScaledMeasure(String measure) {
    if (measure.trim().isEmpty) return '';
    final regex = RegExp(r'^(\d+(?:\.\d+)?)\s*(.*)$');
    final match = regex.firstMatch(measure.trim());
    if (match != null) {
      final number = double.tryParse(match.group(1)!) ?? 0;
      final unit = match.group(2) ?? '';
      if (number > 0) {
        final scaled = (number * (_servings / 4.0));
        final formatted = scaled % 1 == 0 ? scaled.toInt().toString() : scaled.toStringAsFixed(1);
        return '$formatted $unit'.trim();
      }
    }
    return measure;
  }

  List<String> _getInstructionsSteps() {
    return widget.meal.instructions
        .split(RegExp(r'\r?\n|\.'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final isFav = ref.watch(isFavoriteProvider(meal.id));
    final steps = _getInstructionsSteps();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          meal.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppTheme.errorRed : Colors.white,
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggle(meal);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Hero Card
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.brandGoldBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.brandGold.withValues(alpha: 0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: meal.thumbnail.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: meal.thumbnail,
                        httpHeaders: AppConstants.getHeadersForUrl(meal.thumbnail),
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.soup_kitchen_rounded,
                            size: 64,
                            color: AppTheme.brandGold,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.soup_kitchen_rounded,
                          size: 64,
                          color: AppTheme.brandGold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Tagline: Category · Time
            Text(
              '${meal.category.isNotEmpty ? meal.category : 'Breakfast'} · 20 min',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Ingredients Header with Servings Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Servings Adjuster (- 4 servings +)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_servings > 1) {
                          setState(() {
                            _servings--;
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          '−',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '$_servings servings',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _servings++;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ingredient Items List
            if (meal.ingredients.isEmpty)
              const Text(
                '200 g flour\n300 ml milk\n2 eggs',
                style: TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(meal.ingredients.length, (index) {
                  final ing = meal.ingredients[index];
                  final rawMeasure = index < meal.measures.length ? meal.measures[index] : '';
                  final scaledMeasure = _getScaledMeasure(rawMeasure);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      '$scaledMeasure $ing'.trim(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  );
                }),
              ),

            const SizedBox(height: 24),

            // Primary Blue Button: Add to shopping list
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                label: const Text(
                  'Add to shopping list',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  final scaledMeasures = meal.measures.map(_getScaledMeasure).toList();
                  ref.read(shoppingListProvider.notifier).addIngredients(
                        recipeName: meal.name,
                        ingredients: meal.ingredients.isNotEmpty
                            ? meal.ingredients
                            : ['flour', 'milk', 'eggs'],
                        measures: scaledMeasures.isNotEmpty
                            ? scaledMeasures
                            : ['200 g', '300 ml', '2'],
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ingredients for $_servings servings to Shopping List!'),
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Outlined Button: Watch videos for this recipe
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.darkBorderColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_outlined, size: 22),
                label: const Text(
                  'Watch videos for this recipe',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(
                        videoTitle: 'Perfect ${meal.name}',
                        creatorName: 'Dara',
                        meal: meal,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Steps Section
            const Text(
              'Steps',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (steps.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _completedSteps.contains(0) ? Icons.check_box : Icons.check_box_outline_blank,
                      color: _completedSteps.contains(0) ? AppTheme.successGreen : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Whisk dry ingredients',
                        style: TextStyle(
                          color: _completedSteps.contains(0) ? AppTheme.textSecondary : Colors.white,
                          decoration: _completedSteps.contains(0) ? TextDecoration.lineThrough : null,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: List.generate(steps.length, (index) {
                  final isDone = _completedSteps.contains(index);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isDone) {
                          _completedSteps.remove(index);
                        } else {
                          _completedSteps.add(index);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isDone ? Icons.check_box : Icons.check_box_outline_blank,
                            color: isDone ? AppTheme.successGreen : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              steps[index],
                              style: TextStyle(
                                color: isDone ? AppTheme.textSecondary : Colors.white,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

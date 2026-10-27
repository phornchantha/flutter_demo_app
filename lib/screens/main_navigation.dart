import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import 'favourites/favourites_screen.dart';
import 'home/home_screen.dart';
import 'profile/my_profile_screen.dart';
import 'shopping/shopping_screen.dart';
import 'videos/video_feed_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    const screens = [
      HomeScreen(),
      VideoFeedScreen(),
      FavouritesScreen(),
      ShoppingScreen(),
      MyProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.darkCardSurface,
          border: Border(top: BorderSide(color: AppTheme.darkBorderColor, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex > 4 ? 0 : currentIndex,
          onTap: (index) {
            ref.read(navigationIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.darkCardSurface,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: AppTheme.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.soup_kitchen_outlined),
              activeIcon: Icon(Icons.soup_kitchen_rounded),
              label: 'Recipes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ondemand_video_outlined),
              activeIcon: Icon(Icons.ondemand_video_rounded),
              label: 'Videos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart_rounded),
              label: 'Shopping',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

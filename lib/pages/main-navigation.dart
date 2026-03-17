import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/favorite-page.dart';
import 'package:restaurant/pages/home-page.dart';
import 'package:restaurant/pages/search-page.dart';
import 'package:restaurant/pages/settings-page.dart';

import '../providers/navigation-provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const FavoritePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navProvider.currentIndex,
        onDestinationSelected: (index) {
          navProvider.setIndex(index);
        },
        destinations: const [
          NavigationDestination(
            key: Key('home_nav_button'),
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            key: Key('search_nav_button'),
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            key: Key('favorite_nav_button'),
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          NavigationDestination(
            key: Key('settings_nav_button'),
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}

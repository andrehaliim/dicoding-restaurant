import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/components/restaurant-list-item.dart';
import 'package:restaurant/providers/restaurant-provider.dart';
import '../components/setting-drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantProvider>().fetchRestaurants(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: const SettingDrawer(),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: Row(
                  children: [
                    const Text('Restaurant', style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    IconButton(icon: const Icon(Icons.favorite, color: Colors.redAccent), onPressed: () => Navigator.pushNamed(context, '/favorite')),
                  ],
                ),
                actions: [
                  IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.pushNamed(context, '/search')),
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              ),

              if (provider.isLoading)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (provider.error != null)
                SliverFillRemaining(child: Center(child: Text('Error: ${provider.error}')))
              else if (provider.restaurants.isEmpty)
                const SliverFillRemaining(child: Center(child: Text('No restaurants available')))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final data = provider.restaurants[index];

                        return RestaurantListItem(data: data);
                      },
                      childCount: provider.restaurants.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

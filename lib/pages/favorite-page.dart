import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/components/restaurant-list-item.dart';
import 'package:restaurant/providers/restaurant-provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantProvider>().fetchFavoriteRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              if (provider.isLoading)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (provider.error != null)
                SliverFillRemaining(child: Center(child: Text('Error: ${provider.error}')))
              else if (provider.restaurants.isEmpty)
                  const SliverFillRemaining(child: Center(child: Text('No favorite available')))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final data = provider.favoriteRestaurants[index];

                          return RestaurantListItem(data: data);
                        },
                        childCount: provider.favoriteRestaurants.length,
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

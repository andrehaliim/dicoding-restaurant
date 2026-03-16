import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/components/restaurant-list-item.dart';
import 'package:restaurant/providers/restaurant-provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    final query = _searchController.text.trim();

    if (query.isNotEmpty) {
      context.read<RestaurantProvider>().setHasSearched(true);

      context.read<RestaurantProvider>().searchRestaurants(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<RestaurantProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            pinned: true,
            centerTitle: false,
            title: const Text('Search'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: 'Search restaurant name...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _onSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),

          if (!provider.hasSearched)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("Find your favorite restaurant"),
                  ],
                ),
              ),
            )
          else
            Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                if (provider.isSearching) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.searchError != null) {
                  return SliverFillRemaining(
                    child: Center(child: Text(provider.searchError!)),
                  );
                }

                final restaurants = provider.searchResults;

                if (restaurants.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No restaurants found.')),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final data = restaurants[index];
                      return RestaurantListItem(
                        data: data,
                        tagSuffix: '_search',
                      );
                    }, childCount: restaurants.length),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

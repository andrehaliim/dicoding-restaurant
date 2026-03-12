import 'package:flutter/material.dart';
import 'package:restaurant/constants.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<RestaurantListModel>>? _searchFuture;
  bool _hasSearched = false;

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _hasSearched = true;
        _searchFuture = RestaurantProxy().searchRestaurant(context, query);
      });
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
    final textTheme = Theme.of(context).textTheme;

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
                    suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _onSearch),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),

          if (!_hasSearched)
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
            FutureBuilder<List<RestaurantListModel>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(child: Center(child: Text('Error: ${snapshot.error}')));
                }

                final restaurants = snapshot.data ?? [];

                if (restaurants.isEmpty) {
                  return const SliverFillRemaining(child: Center(child: Text('No restaurants found.')));
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final data = restaurants[index];
                      return _buildSearchItem(context, data, colorScheme, textTheme);
                    }, childCount: restaurants.length),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(
    BuildContext context,
    RestaurantListModel data,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: data);
          },
          child: Row(
            children: [
              Hero(
                tag: data.id,
                child: Image.network(
                  '$baseUrl/images/small/${data.pictureId}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 100, child: Icon(Icons.broken_image)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(data.city, style: textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(data.rating.toString(), style: textTheme.labelLarge),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

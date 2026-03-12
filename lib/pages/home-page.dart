import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constants.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      endDrawer: const SettingDrawer(),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: const Text('Restaurant', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final data = provider.restaurants[index];

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: data.id,
                                  child: Image.network(
                                    '$baseUrl/images/medium/${data.pictureId}',
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        const SizedBox(width: 120, height: 100, child: Icon(Icons.broken_image)),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name,
                                          style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 14, color: colorScheme.primary),
                                            const SizedBox(width: 4),
                                            Text(data.city, style: textTheme.bodySmall),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 14, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(
                                              data.rating.toString(),
                                              style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                            ),
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
                    }, childCount: provider.restaurants.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

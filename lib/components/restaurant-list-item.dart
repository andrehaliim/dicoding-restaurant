import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/constants.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/providers/restaurant-provider.dart';

class RestaurantListItem extends StatelessWidget {
  final RestaurantListModel data;

  const RestaurantListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
        child: Stack(
          children: [
            InkWell(
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
                      errorBuilder: (_, __, ___) => const SizedBox(
                          width: 100, child: Icon(Icons.broken_image)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name,
                              style: textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(data.city, style: textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(data.rating.toString(),
                                  style: textTheme.labelLarge),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Consumer<RestaurantProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.favoriteRestaurants.any((fav) => fav.id == data.id);

                  return GestureDetector(
                    onTap: () {
                      provider.toggleFavorite(data);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 18,
                        color: !isFav ? Colors.grey : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
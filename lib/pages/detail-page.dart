import 'package:flutter/material.dart';
import 'package:restaurant/models/restaurant-detail-model.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';

import '../constants.dart';

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<RestaurantDetailModel> future;

  @override
  void initState() {
    future = RestaurantProxy().getRestaurantDetail(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: FutureBuilder<RestaurantDetailModel>(
        future: future,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No detail available'));
          }

          final data = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar.large(  expandedHeight: 300,
                leading: Container(),
                leadingWidth: 0,
                foregroundColor: colorScheme.onSurface,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    bool isCollapsed = top <= (kToolbarHeight + MediaQuery.of(context).padding.top + 10);

                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsetsDirectional.only(
                        start: 16,
                        bottom: 16,
                      ),
                      title: Text(
                        data.name,
                        style: TextStyle(
                          color: isCollapsed
                              ? colorScheme.onSurface
                              : Colors.white,
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: data.id,
                            child: Image.network(
                              '$baseUrl/images/large/${data.pictureId}',
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                              const Icon(Icons.broken_image, size: 80),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                                stops: [0.6, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildInfoChip(context, Icons.star, data.rating.toString(), Colors.amber),
                          const SizedBox(width: 8),
                          _buildInfoChip(context, Icons.location_on, data.city, colorScheme.primary),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInfoChip(context, Icons.home_rounded, data.address, colorScheme.primary),

                      const SizedBox(height: 16),

                      Text("About", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(data.description,
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.justify
                      ),

                      const SizedBox(height: 24),
                      Divider(color: colorScheme.outlineVariant),
                      const SizedBox(height: 16),

                      Text("Menus", style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),

                      const SizedBox(height: 16),
                      Text("Foods", style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _buildHorizontalMenu(data.menus.foods),

                      const SizedBox(height: 16),
                      Text("Drinks", style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _buildHorizontalMenu(data.menus.drinks),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );        },
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }

  Widget _buildHorizontalMenu(List<dynamic> items) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return MenuItem(name: items[index].name);
        },
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  const MenuItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width * 0.4,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
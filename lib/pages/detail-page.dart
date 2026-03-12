import 'package:flutter/material.dart';
import 'package:restaurant/models/restaurant-detail-model.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';

import '../components/menu-items.dart';
import '../constants.dart';

class DetailPage extends StatefulWidget {
  final RestaurantListModel restaurant;
  const DetailPage({super.key, required this.restaurant});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<RestaurantDetailModel> future;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _reviewFocusNode = FocusNode();

  bool isSending = false;

  @override
  void initState() {
    future = RestaurantProxy().getRestaurantDetail(context, widget.restaurant.id);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    _nameFocusNode.dispose();
    _reviewFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 300,
            leading: Container(),
            leadingWidth: 0,
            foregroundColor: colorScheme.onSurface,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                bool isCollapsed = top <= (kToolbarHeight + MediaQuery.of(context).padding.top + 10);

                return FlexibleSpaceBar(
                  titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
                  title: Text(
                    widget.restaurant.name,
                    style: TextStyle(
                      color: isCollapsed ? colorScheme.onSurface : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: widget.restaurant.id,
                        child: Image.network(
                          '$baseUrl/images/large/${widget.restaurant.pictureId}',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 80),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
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

          FutureBuilder<RestaurantDetailModel>(
            future: future,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(child: Center(child: Text('Error: ${snapshot.error}')));
              }

              if (!snapshot.hasData) {
                return const SliverFillRemaining(child: Center(child: Text('No detail available')));
              }

              final data = snapshot.data!;
              return SliverToBoxAdapter(
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
                      Text(data.description, style: textTheme.bodyMedium, textAlign: TextAlign.justify),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      Divider(color: colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: colorScheme.surfaceContainerHigh,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Share your experience",
                                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _reviewController,
                                focusNode: _reviewFocusNode,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Your Review',
                                  border: OutlineInputBorder(),
                                  alignLabelWithHint: true,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: isSending
                                      ? null
                                      : () async {
                                          final name = _nameController.text;
                                          final review = _reviewController.text;

                                          if (name.isNotEmpty && review.isNotEmpty) {
                                            loading();
                                            _nameFocusNode.unfocus();
                                            _reviewFocusNode.unfocus();

                                            try {
                                              final updatedReviews = await RestaurantProxy().sendReview(
                                                context,
                                                data.id,
                                                name,
                                                review,
                                              );

                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Review posted successfully!')),
                                                );
                                                _nameController.clear();
                                                _reviewController.clear();

                                                setState(() {
                                                  data.customerReviews = updatedReviews;
                                                });
                                              }
                                            } catch (e) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(SnackBar(content: Text('Error: $e')));
                                              }
                                            } finally {
                                              if (mounted) loading();
                                            }
                                          }
                                        },
                                  child: isSending
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.send, size: 18),
                                            SizedBox(width: 8),
                                            Text("Submit Review"),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Customer Reviews", style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.customerReviews.length,
                        itemBuilder: (context, index) {
                          final review = data.customerReviews[index];
                          return _buildReviewCard(context, review);
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void loading() {
    setState(() {
      isSending = !isSending;
    });
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
          return MenuItems(name: items[index].name);
        },
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, dynamic review) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(review.name[0].toUpperCase(), style: TextStyle(color: colorScheme.onPrimaryContainer)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(review.date, style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '"${review.review}"',
              style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
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
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: data.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      '$baseUrl/images/medium/${data.pictureId}',
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                      const SizedBox(height: 8),

                      Row(
                        children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 4), Text(data.city)],
                      ),

                      const SizedBox(height: 16),

                      Text(data.description, textAlign: TextAlign.justify),

                      const SizedBox(height: 20),

                      const Text("Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                      SizedBox(
                        height: height * 0.2,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...data.menus.foods.map((food) => MenuItem(name: food.name)),
                            ...data.menus.drinks.map((drink) => MenuItem(name: drink.name)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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

    return Container(
      width: width * 0.4,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Center(
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

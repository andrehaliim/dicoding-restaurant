import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/components/restaurant-list-item.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/providers/restaurant-provider.dart';

class MockRestaurantProvider extends Mock implements RestaurantProvider {}

void main() {
  late MockRestaurantProvider mockProvider;
  late RestaurantListModel mockRestaurant;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockProvider = MockRestaurantProvider();
    mockRestaurant = RestaurantListModel(
      id: "1",
      name: "Test Restaurant",
      city: "Bandung",
      rating: 4.5,
      pictureId: "1",
      description: "Description",
    );

    when(() => mockProvider.favoriteRestaurants).thenReturn(<RestaurantListModel>[]);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<RestaurantProvider>.value(
          value: mockProvider,
          child: RestaurantListItem(data: mockRestaurant, tagSuffix: '_test'),
        ),
      ),
    );
  }

  group('RestaurantListItem Widget Tests', () {
    testWidgets('Should display restaurant name and city', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Test Restaurant'), findsOneWidget);
        expect(find.text('Bandung'), findsOneWidget);
      });
    });

    testWidgets('Should display rating correctly', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('4.5'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });
    });

    testWidgets('Should show red favorite icon when restaurant is favorited',
          (WidgetTester tester) async {
        when(() => mockProvider.favoriteRestaurants).thenReturn(<RestaurantListModel>[mockRestaurant]);

        await mockNetworkImages(() async {
          await tester.pumpWidget(createWidgetUnderTest());

          final iconFinder = find.byIcon(Icons.favorite);
          expect(iconFinder, findsOneWidget);

          final iconWidget = tester.widget<Icon>(iconFinder);
          expect(iconWidget.color, Colors.red);
        });
      },
    );

    testWidgets('Should show grey favorite icon when restaurant is not favorited',
          (WidgetTester tester) async {
            when(() => mockProvider.favoriteRestaurants).thenReturn(<RestaurantListModel>[]);

            await mockNetworkImages(() async {
              await tester.pumpWidget(createWidgetUnderTest());

              final iconFinder = find.byIcon(Icons.favorite);
              expect(iconFinder, findsOneWidget);

              final iconWidget = tester.widget<Icon>(iconFinder);
              expect(iconWidget.color, Colors.grey);
            });
      },
    );
  });
}
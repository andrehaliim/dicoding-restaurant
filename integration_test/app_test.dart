import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Integration Test', () {
    testWidgets('Verify complete user flow: Search, Detail, and Favorite',
            (WidgetTester tester) async {
          // 1. Launch the app
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // 2. Verify the Home Page
          expect(find.text('Restaurant').first, findsOneWidget);

          // 3. Navigate to Search Page
          await tester.tap(find.byKey(const Key('search_nav_button')));
          await tester.pumpAndSettle();

          // 4. Perform a Search
          final searchField = find.byType(TextField);
          await tester.enterText(searchField, 'Melting');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // 5. Tap the first result to go to Detail Page
          final firstResult = find.text('Melting Pot');
          expect(firstResult, findsOneWidget);
          await tester.tap(firstResult);
          await tester.pumpAndSettle();

          // 6. Verify Detail Page content
          expect(find.text('About'), findsOneWidget);
          expect(find.text('Menus'), findsOneWidget);

          // 7. Toggle Favorite
          final favButton = find.byType(FloatingActionButton);
          await tester.tap(favButton);
          await tester.pumpAndSettle();

          // 8. Go back to Home
          final backButton = find.byIcon(Icons.arrow_back);
          await tester.tap(backButton);
          await tester.pumpAndSettle();

          // 9. Find the heart icon on the list item
          final favoriteIconFinder = find.byIcon(Icons.favorite);

          // 10. Verify the icon is now Red (Success)
          final Icon favoriteIcon = tester.widget<Icon>(favoriteIconFinder);
          expect(favoriteIcon.color, Colors.red);
        });
  });
}
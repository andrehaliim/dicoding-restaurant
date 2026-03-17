import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/pages/detail-page.dart';
import 'package:restaurant/pages/favorite-page.dart';
import 'package:restaurant/pages/search-page.dart';
import 'package:restaurant/pages/main-navigation.dart';
import 'package:restaurant/providers/navigation-provider.dart';
import 'package:restaurant/providers/restaurant-provider.dart';
import 'package:restaurant/providers/theme-provider.dart';
import 'package:restaurant/providers/scheduling-provider.dart';
import 'package:restaurant/proxys/db-proxy.dart';
import 'package:restaurant/proxys/restaurant-proxy.dart';
import 'package:restaurant/theme.dart';
import 'package:restaurant/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/helpers/notification-helper.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final NotificationHelper notificationHelper = NotificationHelper();
    final RestaurantProxy restaurantProxy = RestaurantProxy();

    try {
      await notificationHelper.init();

      final List<RestaurantListModel> list = await restaurantProxy.getRestaurantList(null);

      if (list.isNotEmpty) {
        final randomIndex = DateTime.now().millisecond % list.length;
        final restaurant = list[randomIndex];

        await notificationHelper.showNotification(
          id: 1,
          title: "Recommendation for You",
          body: "${restaurant.name} in ${restaurant.city}",
          payload: restaurant.id,
        );
        return Future.value(true);
      }
      return Future.value(true);
    } catch (e) {
      debugPrint("Background Task Error: $e");
      return Future.value(false);
    }
  });
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
  );

  await NotificationHelper().init();
  await DbProxy().database;
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => SchedulingProvider(prefs)),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TextTheme textTheme = createTextTheme(context, "Noto Sans", "Noto Sans");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Dicoding Submission Restaurant App',
      theme: theme.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: theme.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeProvider.seedColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          final restaurant = args['restaurant'] as RestaurantListModel;
          final heroTag = args['suffix'] as String;

          return DetailPage(
            restaurant: restaurant,
            suffix: heroTag,
          );
        },
        '/search': (context) => const SearchPage(),
        '/favorite': (context) => const FavoritePage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/pages/detail-page.dart';
import 'package:restaurant/pages/favorite-page.dart';
import 'package:restaurant/pages/search-page.dart';
import 'package:restaurant/pages/main-navigation.dart';
import 'package:restaurant/providers/restaurant-provider.dart';
import 'package:restaurant/providers/theme-provider.dart';
import 'package:restaurant/providers/scheduling-provider.dart';
import 'package:restaurant/proxys/db-proxy.dart';
import 'package:restaurant/theme.dart';
import 'package:restaurant/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant/helpers/notification-helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper().init();
  await DbProxy().database;
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => SchedulingProvider(prefs)),
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

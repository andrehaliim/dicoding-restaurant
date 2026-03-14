import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/restaurant-list-model.dart';
import 'package:restaurant/pages/detail-page.dart';
import 'package:restaurant/pages/favorite-page.dart';
import 'package:restaurant/pages/search-page.dart';
import 'package:restaurant/pages/main-navigation.dart';
import 'package:restaurant/providers/restaurant-provider.dart';
import 'package:restaurant/providers/theme-provider.dart';
import 'package:restaurant/proxys/db-proxy.dart';
import 'package:restaurant/theme.dart';
import 'package:restaurant/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DbProxy().database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
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
          final data =
              ModalRoute.of(context)!.settings.arguments as RestaurantListModel;
          return DetailPage(restaurant: data);
        },
        '/search': (context) => const SearchPage(),
        '/favorite': (context) => const FavoritePage(),
      },
    );
  }
}

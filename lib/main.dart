import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/pages/detail-page.dart';
import 'package:restaurant/pages/home-page.dart';
import 'package:restaurant/providers/theme-provider.dart';
import 'package:restaurant/theme.dart';
import 'package:restaurant/util.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/detail': (context) => DetailPage(id: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}

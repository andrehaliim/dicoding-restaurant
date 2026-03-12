import 'package:flutter/material.dart';
import 'package:restaurant/pages/detail-page.dart';
import 'package:restaurant/pages/home-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dicoding Submission Restaurant App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blueGrey)),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/detail': (context) => DetailPage(id: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}

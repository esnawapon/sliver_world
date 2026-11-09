import 'package:flutter/material.dart';

import 'home_page.dart';

void main() => runApp(const SliverWorldApp());

class SliverWorldApp extends StatelessWidget {
  const SliverWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World of Slivers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      // darkTheme: ThemeData(
      //   colorSchemeSeed: Colors.indigo,
      //   brightness: Brightness.dark,
      // ),
      home: const HomePage(),
    );
  }
}

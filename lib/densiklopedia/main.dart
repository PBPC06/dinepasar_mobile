import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/home.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/artikel.dart';

void main() {
  runApp(DensiklopediaApp());
}

class DensiklopediaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Densiklopedia',
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePageArticle(),
        '/artikel': (context) => ArtikelPage(),
      },
    );
  }
}
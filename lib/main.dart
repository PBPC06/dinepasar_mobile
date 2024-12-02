import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/main/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DINEPASAR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.yellow,
        ).copyWith(secondary: const Color.fromRGBO(255, 238, 169, 100)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
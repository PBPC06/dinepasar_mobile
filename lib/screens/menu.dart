import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
    MyHomePage({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinepasar'),
      ),
      body: Center(
        child: const Text('Welcome to Dinepasar!'),
      ),
      drawer: const LeftDrawer(),
    );
  }
}

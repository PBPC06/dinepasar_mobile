import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final String username;

  WelcomeSection({required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'WELCOME, $username!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(202, 138, 4, 1), // Warna teks
        ),
      ),
    );
  }
}

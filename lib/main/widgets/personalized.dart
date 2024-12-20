import 'package:flutter/material.dart';

class PersonalizedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get Personalized Recommendations!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(202, 138, 4, 1), // Warna teks diperbarui
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Discover dishes and restaurants tailored to your taste. Click the button below to update your profile and preferences.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            child: Text('Go to My Profile'),
          ),
        ],
      ),
    );
  }
}
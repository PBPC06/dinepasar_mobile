import 'package:flutter/material.dart';
class ThreeStepsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make Your Experience Better in 3 Easy Steps',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(202, 138, 4, 1), // Warna teks diperbarui
            ),
          ),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/search'),
                    child: Text('Search'),
                  ),
                  SizedBox(height: 4),
                  Text('Find amazing dishes!'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/favorite'),
                    child: Text('Favorite'),
                  ),
                  SizedBox(height: 4),
                  Text('Save what you love.'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/review'),
                    child: Text('Review'),
                  ),
                  SizedBox(height: 4),
                  Text('Share your experience.'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class WhyDinepasarSection extends StatelessWidget {
  const WhyDinepasarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Dinepasar?',
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
                  Icon(Icons.restaurant, size: 40, color: Colors.orange),
                  SizedBox(height: 4),
                  Text('Variety of Dishes', style: TextStyle(fontSize: 14)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.star, size: 40, color: Colors.orange),
                  SizedBox(height: 4),
                  Text('Top Ratings', style: TextStyle(fontSize: 14)),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.map, size: 40, color: Colors.orange),
                  SizedBox(height: 4),
                  Text('Map Details', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

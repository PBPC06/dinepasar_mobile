import 'package:flutter/material.dart';

class DensiklopediaPreviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Densiklopedia!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(202, 138, 4, 1), // Warna teks diperbarui
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Card(
                  child: Container(
                    width: 120,
                    child: Center(child: Text('Article 1')),
                  ),
                ),
                SizedBox(width: 10),
                Card(
                  child: Container(
                    width: 120,
                    child: Center(child: Text('Article 2')),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/densiklopedia'),
            child: Text('View All Articles'),
          ),
        ],
      ),
    );
  }
}

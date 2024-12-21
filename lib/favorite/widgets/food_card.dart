// lib/favorite/widgets/food_card.dart
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final String image;
  final String category;
  final double rating;
  final int price;

  const FoodCard({
    Key? key,
    required this.name,
    required this.image,
    required this.category,
    required this.rating,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Image.network(
          image.isNotEmpty ? image : 'https://via.placeholder.com/60',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 60);
          },
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4), // Jarak antara kategori dan harga
            Text(
              'Rp $price',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.yellow, // Warna kuning untuk harga
              ),
            ),
            const SizedBox(height: 4), // Jarak antara harga dan rating
            Text(
              '⭐ $rating / 5',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

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
          image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
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
            Text(category, style: const TextStyle(fontSize: 14)),
            Text('⭐ $rating / 5', style: const TextStyle(fontSize: 14)),
          ],
        ),
        trailing: Text(
          'Rp $price',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

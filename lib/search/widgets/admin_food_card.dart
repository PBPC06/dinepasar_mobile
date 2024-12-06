import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';

class AdminFoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminFoodCard({
    super.key,
    required this.food,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(food.fields.gambar, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(food.fields.namaMakanan),
        subtitle: Text('Rp ${food.fields.harga.toString()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}

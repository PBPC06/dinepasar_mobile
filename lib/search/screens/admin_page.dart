import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/search/widgets/admin_food_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Food> foods = []; // Dummy list untuk sementara

  void addFood() {
    // Tambahkan logika untuk menambah makanan
  }

  void editFood(Food food) {
    // Tambahkan logika untuk mengedit makanan
  }

  void deleteFood(Food food) {
    setState(() {
      foods.remove(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Manage Foods')),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return AdminFoodCard(
            food: food,
            onEdit: () => editFood(food),
            onDelete: () => deleteFood(food),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFood,
        child: const Icon(Icons.add),
      ),
    );
  }
}

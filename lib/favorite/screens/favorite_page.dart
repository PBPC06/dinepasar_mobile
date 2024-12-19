import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/favorite/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          favoriteItems = data.map((item) {
            return {
              'name': item['food']['nama_makanan'],
              'image': item['food']['gambar'],
              'category': item['food']['kategori'],
              'price': item['food']['harga'],
              'rating': item['food']['rating'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Don't have any favorite :(",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Visit the homepage to select a food item\nand start adding to your favorite.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Image.network(
              item['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(
              item['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['category'], style: const TextStyle(fontSize: 14)),
                Text('⭐ ${item['rating']} / 5', style: const TextStyle(fontSize: 14)),
              ],
            ),
            trailing: Text(
              'Rp ${item['price']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteItems.isEmpty
              ? _buildEmptyFavorites()
              : _buildFavoritesList(favoriteItems),
    );
  }
}

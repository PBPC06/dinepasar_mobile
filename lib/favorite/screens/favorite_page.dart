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
  List<Map<String, dynamic>> recommendedItems = [];
  bool isLoading = true;
  bool isFavoriteSelected = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
    _fetchRecommended();
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

  Future<void> _fetchRecommended() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/recommended/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          recommendedItems = data.map((item) {
            return {
              'name': item['nama_makanan'],
              'image': item['gambar'],
              'category': item['kategori'],
              'price': item['harga'],
              'rating': item['rating'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load recommended items');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildEmptyState(String message, String subMessage, String imagePath) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Map<String, dynamic>> items) {
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
      body: Column(
        children: [
          // Toggle Buttons
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavoriteSelected = true;
                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: isFavoriteSelected ? const Color(0xFFFBC02D) : const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Your Favorite',
                        style: TextStyle(
                          color: isFavoriteSelected ? Colors.white : const Color(0xFF242424),
                          fontSize: 16,
                          fontWeight: isFavoriteSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavoriteSelected = false;
                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: isFavoriteSelected ? const Color(0xFFEDEDED) : const Color(0xFFFBC02D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Recommended',
                        style: TextStyle(
                          color: isFavoriteSelected ? const Color(0xFF242424) : Colors.white,
                          fontSize: 16,
                          fontWeight: isFavoriteSelected ? FontWeight.w400 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isFavoriteSelected
                    ? (favoriteItems.isEmpty
                        ? _buildEmptyState(
                            "Don't have any favorite :(",
                            "Visit the homepage to select a food item and start adding to your favorite.",
                            'assets/images/empty_favorite.png',
                          )
                        : _buildItemList(favoriteItems))
                    : (recommendedItems.isEmpty
                        ? _buildEmptyState(
                            "Don't have any recommendation :(",
                            "Add some items to your favorites to get personalized recommendations.",
                            'assets/images/empty_recommendation.png',
                          )
                        : _buildItemList(recommendedItems)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<FoodItem> favoriteItems = [];
  List<FoodItem> recommendedItems = [];
  bool isLoading = true;
  bool isFavoriteSelected = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final request = context.read<CookieRequest>();
    await Future.wait([
      _fetchFavorites(request),
      _fetchRecommended(request),
    ]);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchFavorites(CookieRequest request) async {
    await _fetchItems(
      request: request,
      url: 'http://127.0.0.1:8000/favorite/api/',
      onSuccess: (data) {
        setState(() {
          favoriteItems = data;
        });

        // Log daftar favorit yang dimuat
        print('Loaded favorite items:');
        for (var item in favoriteItems) {
          print('Favorite ID: ${item.id}, Name: ${item.namaMakanan}');
        }
      },
    );
  }

  Future<void> _fetchRecommended(CookieRequest request) async {
    await _fetchItems(
      request: request,
      url: 'http://127.0.0.1:8000/favorite/recommended/',
      onSuccess: (data) {
        setState(() {
          recommendedItems = data;
        });

        // Log daftar rekomendasi
        print('Recommended items:');
        for (var item in recommendedItems) {
          print('Recommended ID: ${item.id}, Name: ${item.namaMakanan}');
        }
      },
    );
  }

  Future<void> _fetchItems({
    required CookieRequest request,
    required String url,
    required Function(List<FoodItem>) onSuccess,
  }) async {
    try {
      final response = await request.get(url);
      print('Server Response: $response'); // Log data JSON

      if (response != null && response is List) {
        final data = response.map((item) {
          try {
            return FoodItem.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing item: $item, Error: $e');
            return null; // Skip item jika parsing gagal
          }
        }).where((item) => item != null).toList();

        onSuccess(data.cast<FoodItem>());
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _deleteFavorite(int favoriteId) async {
    final request = context.read<CookieRequest>();
    try {
      print('Deleting favorite with ID: $favoriteId');
      final response = await request.post(
        'http://127.0.0.1:8000/favorite/delete/$favoriteId/',
        {},
      );

      if (response['message'] == 'Item removed from favorites.') {
        setState(() {
          favoriteItems.removeWhere((item) => item.id == favoriteId);
        });
        print('Successfully deleted favorite with ID: $favoriteId');
      } else {
        print('Failed to delete favorite: ${response['error']}');
      }
    } catch (e) {
      print('Error deleting favorite: $e');
    }
  }

  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFBC02D) : const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF242424),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, String subMessage, String imagePath) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 150, height: 150),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(subMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildItemList(List<FoodItem> items, bool isFavorite) {
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
              item.gambar.isNotEmpty ? item.gambar : 'https://via.placeholder.com/60',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 60);
              },
            ),
            title: Text(
              item.namaMakanan,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.kategori, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Rp ${item.harga}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 4),
                Text('⭐ ${item.rating} / 5', style: const TextStyle(fontSize: 14)),
              ],
            ),
            trailing: isFavorite
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteFavorite(item.id);
                    },
                  )
                : null, // Jangan tampilkan tombol hapus pada rekomendasi
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
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton('Your Favorite', isFavoriteSelected, () {
                  setState(() {
                    isFavoriteSelected = true;
                  });
                }),
                _buildTabButton('Recommended', !isFavoriteSelected, () {
                  setState(() {
                    isFavoriteSelected = false;
                  });
                }),
              ],
            ),
          ),
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
                        : _buildItemList(favoriteItems, true))
                    : (recommendedItems.isEmpty
                        ? _buildEmptyState(
                            "Don't have any recommendation :(",
                            "Add some items to your favorites to get personalized recommendations.",
                            'assets/images/empty_recommendation.png',
                          )
                        : _buildItemList(recommendedItems, false)),
          ),
        ],
      ),
    );
  }
}

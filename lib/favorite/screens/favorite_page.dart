import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../widgets/food_card.dart';

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
      print('Server Response: $response');

      if (response != null && response is List) {
        final data = response
            .map((item) => FoodItem.fromJson(item as Map<String, dynamic>))
            .toList();
        onSuccess(data);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching data: $e');
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

  Widget _buildItemList(List<FoodItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FoodCard(
          name: item.fields.namaMakanan,
          image: item.fields.gambar,
          category: item.fields.kategori,
          rating: item.fields.rating,
          price: item.fields.harga,
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
                : (isFavoriteSelected ? favoriteItems : recommendedItems).isEmpty
                    ? _buildEmptyState(
                        isFavoriteSelected
                            ? "Don't have any favorite :(" 
                            : "Don't have any recommendation :(",
                        isFavoriteSelected
                            ? "Visit the homepage to select a food item and start adding to your favorite."
                            : "Add some items to your favorites to get personalized recommendations.",
                        isFavoriteSelected
                            ? 'assets/images/empty_favorite.png'
                            : 'assets/images/empty_recommendation.png',
                      )
                    : _buildItemList(isFavoriteSelected ? favoriteItems : recommendedItems),
          ),
        ],
      ),
    );
  }
}

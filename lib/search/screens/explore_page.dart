
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/search/widgets/food_card.dart';
import 'package:dinepasar_mobile/search/screens/placeholder/approval_page.dart';
import 'package:dinepasar_mobile/search/screens/placeholder/details_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  String priceRange = 'all';

  // Fungsi untuk mengambil data makanan
  Future<List<Food>> fetchProduct(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/search/api/foods/');
    var data = response;

    List<Food> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Food.fromJson(d));
      }
    }
    return listProduct;
  }

  // Fungsi untuk menangani perubahan pencarian
  void handleSearch(String? query) {
    setState(() {
      searchQuery = query ?? '';
    });
  }

  // Fungsi untuk menangani perubahan kategori
  void handleCategoryChange(String? category) {
    setState(() {
      selectedCategory = category ?? 'All';
    });
  }

  // Fungsi untuk menangani perubahan rentang harga
  void handlePriceRangeChange(String? range) {
    setState(() {
      priceRange = range ?? 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Let\'s Find Your Food!',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFEFCEC),
      ),
      body: Column(
        children: [
          // Pencarian dan filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                // Pencarian
                TextField(
                  onChanged: handleSearch,
                  decoration: InputDecoration(
                    hintText: 'Search for food...',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16), // Memberikan space antara pencarian dan filter
                // Filter kategori dan harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // This centers the filters horizontally
                  children: [
                    // Filter kategori dengan padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: handleCategoryChange,
                        items: ['All', 'Ayam Betutu', 'Sate', 'Es', 'Ayam', 'Pepes', 'Nasi', 'Sayur', 'Jajanan', 'Sambal', 'Tipat', 'Rujak', 'Bebek', 'Ikan', 'Kopi', 'Lawar', 'Babi Guling']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    // Filter harga dengan padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: priceRange,
                        onChanged: handlePriceRangeChange,
                        items: ['all', 'Under 50k', '50k-100k', 'Above 100k']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tampilkan data makanan
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: fetchProduct(request),
              builder: (context, AsyncSnapshot<List<Food>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No foods available in Dinepasar'));
                }

                final foods = snapshot.data!;

                // Filter berdasarkan pencarian dan kategori
                final filteredFoods = foods.where((food) {
                  bool matchesSearch = food.fields.namaMakanan.toLowerCase().contains(searchQuery.toLowerCase());
                  bool matchesCategory = selectedCategory == 'All' || food.fields.kategori == selectedCategory;
                  bool matchesPrice = true;

                  // Filter berdasarkan harga
                  if (priceRange == 'Under 50k') {
                    matchesPrice = food.fields.harga < 50000;
                  } else if (priceRange == '50k-100k') {
                    matchesPrice = food.fields.harga >= 50000 && food.fields.harga <= 100000;
                  } else if (priceRange == 'Above 100k') {
                    matchesPrice = food.fields.harga > 100000;
                  }

                  return matchesSearch && matchesCategory && matchesPrice;
                }).toList();

                // Jika tidak ada makanan yang cocok
                if (filteredFoods.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No foods found based on your search.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  );
                }

                // Jika ada makanan yang cocok
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return FoodCard(
                      food: food,
                      onApprove: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ApprovalPage()),
                        );
                      },
                      onMore: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(foodId: food.pk), // Pastikan foodId dikirim
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
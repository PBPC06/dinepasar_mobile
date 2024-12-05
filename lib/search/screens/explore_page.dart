import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/search/widgets/search_bar.dart' as custom;

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  String priceRange = '';

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

  void handleSearch(String? query) {
    setState(() {
      searchQuery = query ?? '';
    });
  }

  void handleCategoryChange(String? category) {
    setState(() {
      selectedCategory = category ?? '';
    });
  }

  void handlePriceRangeChange(String? range) {
    setState(() {
      priceRange = range ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Find Your Food!',
          style: const TextStyle(
            fontFamily: 'Roboto', // Font yang lebih enak dibaca
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
          // Search Bar with padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: custom.SearchBar(
              onSearch: handleSearch,
              onCategoryChange: handleCategoryChange,
              onPriceRangeChange: handlePriceRangeChange,
            ),
          ),

          // Food Cards Grid
          Expanded(
            child: FutureBuilder(
              future: fetchProduct(request),
              builder: (context, AsyncSnapshot<List<Food>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada makanan di Dinepasar'));
                }

                final foods = snapshot.data!;

                // Apply search query, category, and price filter
                final filteredFoods = foods.where((food) {
                  bool matchesSearch = food.fields.namaMakanan.toLowerCase().contains(searchQuery.toLowerCase());
                  bool matchesCategory = selectedCategory == 'All' || food.fields.kategori == selectedCategory;
                  bool matchesPrice = true;

                  if (priceRange == 'Under 50k') {
                    matchesPrice = food.fields.harga < 50000;
                  } else if (priceRange == '50k-100k') {
                    matchesPrice = food.fields.harga >= 50000 && food.fields.harga <= 100000;
                  } else if (priceRange == 'Above 100k') {
                    matchesPrice = food.fields.harga > 100000;
                  }

                  return matchesSearch && matchesCategory && matchesPrice;
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // Menyesuaikan ukuran card agar lebih rapi
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5, // Menambahkan efek bayangan pada card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                food.fields.gambar,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    color: Colors.yellow,
                                    size: 48,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Food Name
                                Text(
                                  food.fields.namaMakanan,
                                  style: const TextStyle(
                                    fontSize: 14, // Menambah ukuran font agar lebih terbaca
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Food Price
                                Text(
                                  'Rp ${food.fields.harga.toString()}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Food Rating
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                    Text(
                                      food.fields.rating.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Food Description
                                Text(
                                  food.fields.deskripsi,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

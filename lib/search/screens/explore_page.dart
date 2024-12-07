import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/search/widgets/food_card.dart';
import 'package:dinepasar_mobile/search/widgets/search_bar.dart' as custom;
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: custom.SearchBar(
              onSearch: handleSearch,
              onCategoryChange: handleCategoryChange,
              onPriceRangeChange: handlePriceRangeChange,
            ),
          ),
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
                          // Navigasi ke halaman Approval (placeholder)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ApprovalPage()),
                          );
                        },
                        onMore: () {
                          // Navigasi ke halaman Details (placeholder)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DetailsPage()),
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

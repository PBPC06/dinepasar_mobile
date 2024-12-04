import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/widgets/category_slider.dart';
import 'package:dinepasar_mobile/search/widgets/product_card.dart';
import 'package:dinepasar_mobile/search/screens/productentry_form.dart'; 
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ScrollController _scrollController = ScrollController();
  List<String> categories = ['All', 'Ayam', 'Sate', 'Dessert', 'Minuman', 'Jajanan', 'Sambal'];
  String selectedCategory = 'All';
  int currentPage = 1;

  List<Map<String, dynamic>> products = [
    {'name': 'Nasi Ayam', 'description': 'Ayam bakar enak', 'price': 25000, 'rating': 4.5, 'image': 'https://awsimages.detik.net.id/community/media/visual/2023/02/06/1385476906_169.jpeg?w=600&q=90'},
    {'name': 'Sate Kambing', 'description': 'Sate kambing gurih', 'price': 30000, 'rating': 4.8, 'image': 'https://assets.unileversolutions.com/recipes-v2/252622.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFFEFCEC),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Filter Page or show filter options
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 161, 35),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            CategorySlider(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
            if (currentPage < 3)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage += 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Load More'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductEntryFormPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 193, 7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

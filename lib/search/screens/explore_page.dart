import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/widgets/search_bar.dart' as custom;
import 'package:dinepasar_mobile/search/widgets/category_slider.dart';
import 'package:dinepasar_mobile/search/widgets/product_card.dart';

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

  // Simulating a list of dummy products
  List<Map<String, dynamic>> products = [
    {'name': 'Nasi Ayam', 'description': 'Ayam bakar enak', 'price': 25000, 'rating': 4.5, 'image': 'https://awsimages.detik.net.id/community/media/visual/2023/02/06/1385476906_169.jpeg?w=600&q=90'},
    {'name': 'Sate Kambing', 'description': 'Sate kambing gurih Sate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurih', 'price': 30000, 'rating': 4.8, 'image': 'https://assets.unileversolutions.com/recipes-v2/252622.png'},
    {'name': 'Sate Kambing', 'description': 'Sate kambing gurih Sate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurih', 'price': 30000, 'rating': 4.8, 'image': 'https://assets.unileversolutions.com/recipes-v2/252622.png'},
    {'name': 'Nasi Ayam', 'description': 'Ayam bakar enak', 'price': 25000, 'rating': 4.5, 'image': 'https://awsimages.detik.net.id/community/media/visual/2023/02/06/1385476906_169.jpeg?w=600&q=90'},
    {'name': 'Sate Kambing', 'description': 'Sate kambing gurih Sate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurihSate kambing gurih', 'price': 30000, 'rating': 4.8, 'image': 'https://assets.unileversolutions.com/recipes-v2/252622.png'},
    // More products...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(
            fontFamily: 'Roboto', // Using the default font (similar to Poppins)
            fontSize: 24, // Adjust the font size to be more aesthetic
            fontWeight: FontWeight.w600, // Slightly bold for emphasis
            letterSpacing: 1.2, // Spacing between letters for better readability
          ),
        ),
        backgroundColor: Color.fromRGBO(254, 252, 232, 1), // Light yellow color
        centerTitle: true, // Center the title in the AppBar
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Filter Icon next to it
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Expanded Search Bar to take up the available space
                  const Expanded(
                    child: custom.SearchBar(),
                  ),
                  const SizedBox(width: 10),
                  // Filter Icon with background
                  GestureDetector(
                    onTap: () {
                      // Navigate to Filter Page or show filter options
                      // TODO: Implement filter functionality here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[700], // Yellow background
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      child: const Icon(
                        Icons.filter_list,  // Filter icon
                        color: Colors.black, // Black icon color
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Categories
            CategorySlider(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            // Product Cards
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

            // Pagination Button
            if (currentPage < 3) // Example for pagination limit
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage += 1;
                      // TODO: Load more products here
                    });
                  },
                  child: const Text('Load More'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

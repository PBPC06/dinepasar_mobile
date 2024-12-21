import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String?>? onSearch;
  final ValueChanged<String?>? onCategoryChange;
  final ValueChanged<String?>? onPriceRangeChange;
  final String? selectedCategory;
  final String? selectedPriceRange;

  const SearchBar({
    super.key,
    required this.onSearch,
    required this.onCategoryChange,
    required this.onPriceRangeChange,
    this.selectedCategory,
    this.selectedPriceRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar with subtle shadow and rounded corners
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari makanan...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onChanged: onSearch,
            ),
          ),
        ),
        
        // Row with Category and Price Range Dropdowns
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category Dropdown with rounded corners and custom style
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButton<String?>(
                    value: selectedCategory,
                    isExpanded: true,
                    hint: const Text('Pilih Kategori', style: TextStyle(color: Colors.grey)),
                    onChanged: onCategoryChange,
                    items: [
                      'All', 'Ayam Betutu', 'Sate', 'Es', 'Ayam', 'Pepes', 'Nasi',
                      'Sayur', 'Jajanan', 'Sambal', 'Tipat', 'Rujak', 'Bebek',
                      'Ikan', 'Kopi', 'Lawar', 'Babi Guling',
                    ].map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              
              // Price Range Dropdown with rounded corners and custom style
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButton<String?>(
                    value: selectedPriceRange,
                    isExpanded: true,
                    hint: const Text('Pilih Rentang Harga', style: TextStyle(color: Colors.grey)),
                    onChanged: onPriceRangeChange,
                    items: [
                      'All', 'Under 50k', '50k-100k', 'Above 100k',
                    ].map((range) {
                      return DropdownMenuItem(
                        value: range,
                        child: Text(range),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


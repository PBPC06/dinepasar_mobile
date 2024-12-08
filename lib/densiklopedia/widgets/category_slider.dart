import 'package:flutter/material.dart';

class CategorySlider extends StatefulWidget {
  final Function(int) onCategorySelected;
  final int defaultIndex;

  const CategorySlider({
    Key? key,
    required this.onCategorySelected,
    this.defaultIndex = 0,
  }) : super(key: key);

  @override
  _CategorySliderState createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  late int selectedIndex;

  final List<String> categories = [
    'Home',
    'Artikel',
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 16),
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              // Panggil callback untuk navigasi
              widget.onCategorySelected(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFC67C4E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFC67C4E), width: 1),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF303030),
                    fontSize: 14,
                    fontFamily: 'Sora',
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
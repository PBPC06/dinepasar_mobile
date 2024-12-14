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
  int? hoveredIndex;

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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          bool isHovered = index == hoveredIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onCategorySelected(index);
            },
            child: MouseRegion(
              onEnter: (_) => setState(() {
                hoveredIndex = index;
              }),
              onExit: (_) => setState(() {
                hoveredIndex = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.yellow[700]
                      : isHovered
                          ? Colors.yellow[500]
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey[800],
                      fontSize: 14,
                      fontFamily: 'Sora',
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
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
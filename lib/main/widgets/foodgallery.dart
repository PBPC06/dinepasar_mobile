import 'package:flutter/material.dart';
class FoodGallerySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('lib/main/assets/food1.png', fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 10),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('lib/main/assets/food2.png', fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 10),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('lib/main/assets/food3.png', fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 10),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('lib/main/assets/food4.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}


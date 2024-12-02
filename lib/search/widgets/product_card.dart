import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5, // Add elevation for a modern shadow effect
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  product['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Rating (1 star with rating text)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star, // Show one filled star
                        color: Colors.yellow[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      // Show the numeric rating
                      Text(
                        '${product['rating']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Truncate the description if it's too long
                Text(
                  product['description'],
                  style: const TextStyle(fontSize: 12),
                  maxLines: 4, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
                ),
                const SizedBox(height: 8),
                // Row for price and action buttons (Checkmark and See More)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${product['price']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        // Checkmark button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[700], // Yellow background
                            borderRadius: BorderRadius.circular(6), // Smaller border radius
                          ),
                          child: IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            color: Colors.white,
                            iconSize: 18, // Smaller icon size
                            onPressed: () {
                              // Add your onPressed logic here
                            },
                          ),
                        ),
                        const SizedBox(width: 6), // Space between buttons
                        // See More button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[700], // Yellow background
                            borderRadius: BorderRadius.circular(6), // Smaller radius
                          ),
                          child: IconButton(
                            icon: Icon(Icons.more_horiz),
                            color: Colors.white,
                            iconSize: 18, // Smaller icon size
                            onPressed: () {
                              // Add your onPressed logic here
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Filter by:'),
        DropdownButton<String>(
          items: const [
            DropdownMenuItem(value: 'Popular', child: Text('Popular')),
            DropdownMenuItem(value: 'Newest', child: Text('Newest')),
            DropdownMenuItem(value: 'Rating', child: Text('Rating')),
          ],
          onChanged: (value) {
            // TODO: Handle filter changes
          },
        ),
      ],
    );
  }
}

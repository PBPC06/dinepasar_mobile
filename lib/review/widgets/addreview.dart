// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';

class AddReviewPage extends StatefulWidget {
  final int? foodId;

  const AddReviewPage({super.key, this.foodId});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? _rating;
  String _reviewMessage = "";
  int? _selectedFoodId;
  List<Food> _foodList = [];

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing AddReviewPage and fetching food list.');
    _fetchFoodList();
    _selectedFoodId = widget.foodId;
  }

  Future<void> _fetchFoodList() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('http://127.0.0.1:8000/search/api/foods/');
    var data = response;
    if (data is List) {
      setState(() {
        _foodList = data.map((item) => Food.fromJson(item)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review | Dinepasar'),
        backgroundColor: const Color(0xFFFEFCEC),
      ),
      body: Center(
        child: _foodList.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Dropdown to select Food
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Select Food',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedFoodId,
                          items: _foodList.map((food) {
                            return DropdownMenuItem<int>(
                              value: food.pk,
                              child: Text(food.fields.namaMakanan),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedFoodId = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a food item';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Rating Bar
                        RatingBar.builder(
                          initialRating: _rating?.toDouble() ?? 0,
                          minRating: 1,
                          maxRating: 5,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 45.0,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          updateOnDrag: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double newRating) {
                            setState(() {
                              _rating = newRating;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        // Review Message
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Review Message',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {
                              _reviewMessage = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Review message cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Submit Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedFoodId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please select a food item')),
                                );
                                return;
                              }

                              if (_rating == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please provide a rating')),
                                );
                                return;
                              }

                              final updateData = {
                                'food_id': _selectedFoodId.toString(),
                                'rating': _rating.toString(),
                                'review_message': _reviewMessage,
                              };

                              try {
                                final response = await request.post(
                                  "http://127.0.0.1:8000/review/add-review-flutter/",
                                  updateData,
                                );

                                if (response["status"] == "success") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Review added successfully')),
                                  );
                                  Navigator.pop(context, updateData);
                                } else {
                                  String message = response["message"] ??
                                      'Failed to add review';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to add review: $message')),
                                  );
                                }
                              } catch (e) {
                                debugPrint('Error adding review: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Terjadi kesalahan saat menambahkan review')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEFCEC),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text('Submit Review'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEFCEC),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

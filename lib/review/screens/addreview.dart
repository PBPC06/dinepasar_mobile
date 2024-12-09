import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/review/review.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({Key? key}) : super(key: key);

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  int? _rating;
  String _reviewMessage = "";
  int? _selectedFoodId;
  List<Food> _foodList = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodList();
  }

  Future<void> _fetchFoodList() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('http://127.0.0.1:8000/search/api/foods/');

    if (response["status"] == "success") {
      List<dynamic> data = response["data"];
      setState(() {
        _foodList = data.map((item) => Food.fromJson(item)).toList();
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load food list')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review | Dinepasar'),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: SingleChildScrollView(
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
                          value: food.pk, child: Text(food.fields.namaMakanan));
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
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    updateOnDrag: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (double newRating) {
                      setState(() {
                        _rating = newRating.toInt();
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
                                content: Text('Please select a food item')),
                          );
                          return;
                        }

                        final response = await request.post(
                          "http://127.0.0.1:8000/review/add-review/",
                          {
                            'food': _selectedFoodId.toString(),
                            'rating': _rating.toString(),
                            'review_message': _reviewMessage,
                          },
                        );

                        if (response["status"] == "success") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Review added successfully')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReviewPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to add review')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Submit Review'),
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/review/models/review_entry.dart';

class AllReviewsPage extends StatefulWidget {
  const AllReviewsPage({Key? key}) : super(key: key);

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  late Future<List<FoodReview>> _allReviewsFuture;
  late Future<List<Food>> _allFoodsFuture;

  // Pemetaan ID Makanan ke Objek Food
  Map<int, Food> _foodMap = {};

  @override
  void initState() {
    super.initState();
    _allFoodsFuture = _fetchAllFoods();
    _allReviewsFuture = _fetchAllReviews();
  }

  // Fungsi untuk mengambil semua makanan
  Future<List<Food>> _fetchAllFoods() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('http://127.0.0.1:8000/search/api/foods/');

    if (response['status'] == 'success') {
      List<dynamic> foodsJson = response['data'];
      List<Food> foods = foodsJson.map((item) => Food.fromJson(item)).toList();
      // Membuat peta ID Makanan ke Objek Food
      _foodMap = {for (var food in foods) food.pk: food};
      return foods;
    } else {
      throw Exception('Failed to load foods: ${response['message']}');
    }
  }

  // Fungsi untuk mengambil semua ulasan
  Future<List<FoodReview>> _fetchAllReviews() async {
    final request = context.read<CookieRequest>();
    final response = await request.get(
        "http://127.0.0.1:8000/review/json/"); // Sesuaikan dengan endpoint Anda

    if (response['status'] == 'success') {
      List<dynamic> reviewsJson = response['data'];
      List<FoodReview> reviews = foodReviewFromJson(jsonEncode(reviewsJson));
      return reviews;
    } else {
      throw Exception('Failed to load reviews: ${response['message']}');
    }
  }

  // Fungsi untuk menampilkan modal edit ulasan
  void _showEditModal(BuildContext context, FoodReview review) {
    final _formKey = GlobalKey<FormState>();
    int rating = review.fields.rating;
    String message = review.fields.reviewMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Review'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Menampilkan Nama Makanan
                        Text('Food ID: ${review.fields.food}'),
                        const SizedBox(height: 10),
                        RatingBar.builder(
                          initialRating: rating.toDouble(),
                          minRating: 1,
                          maxRating: 5,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating.toInt();
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: message,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Review Message',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Review message cannot be empty!";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            message = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final request = context.read<CookieRequest>();
                  final editUrl =
                      "http://127.0.0.1:8000/edit/${review.pk}/"; // Sesuaikan dengan endpoint edit Anda

                  final response = await request.post(
                    editUrl,
                    {
                      'rating': rating.toString(),
                      'review_message': message,
                    },
                  );

                  if (response['status'] == 'success') {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Review updated successfully')),
                    );
                    setState(() {
                      _allReviewsFuture = _fetchAllReviews();
                    });
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Failed to update review: ${response['message']}')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus ulasan
  void _deleteReview(int reviewId) async {
    final request = context.read<CookieRequest>();
    final deleteUrl =
        "http://127.0.0.1:8000/delete-review/$reviewId/"; // Sesuaikan dengan endpoint delete Anda

    final response = await request.post(
      deleteUrl,
      {},
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully')),
      );
      setState(() {
        _allReviewsFuture = _fetchAllReviews();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete review: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FoodReview>>(
      future: _allReviewsFuture,
      builder: (context, snapshot) {
        // Menampilkan indikator loading saat data sedang diambil
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Menampilkan pesan error jika terjadi kesalahan
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Menampilkan pesan jika tidak ada ulasan
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No reviews available!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        // Menampilkan daftar ulasan
        else {
          List<FoodReview> reviews = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _allReviewsFuture = _fetchAllReviews();
                _allFoodsFuture = _fetchAllFoods();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final foodId = review.fields.food;
                final food = _foodMap[foodId];

                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.yellow.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Menampilkan gambar makanan jika tersedia
                        food != null && food.fields.gambar.isNotEmpty
                            ? Image.network(
                                food.fields.gambar,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.fastfood,
                                    size: 40, color: Colors.white),
                              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menampilkan nama makanan
                              Text(
                                food != null
                                    ? food.fields.namaMakanan
                                    : 'Unknown Food',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Menampilkan rating
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${review.fields.rating} / 5',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Menampilkan pesan ulasan
                              Text(
                                '"${review.fields.reviewMessage}"',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              // Menampilkan informasi pengguna dan tanggal ulasan
                              Text(
                                'Reviewed by ${review.fields.user} on ${_formatDate(review.fields.createdAt)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Tombol Edit dan Delete
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        _showEditModal(context, review),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 12),
                                    ),
                                    child: const Text('Edit'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _deleteReview(review.pk),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 12),
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  // Fungsi untuk memformat tanggal
  String _formatDate(DateTime date) {
    // Format tanggal sebagai "d M Y", misalnya "09 Dec 2024"
    return "${date.day} ${_monthString(date.month)} ${date.year}";
  }

  String _monthString(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

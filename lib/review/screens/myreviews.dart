import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/review/models/review_entry.dart';
import 'addreview.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  late Future<List<Map<String, dynamic>>> _myReviewsFuture;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _initializeUsername();
  }

  Future<void> _initializeUsername() async {
    try {
      final request = context.read<CookieRequest>();
      final response =
          await request.get("http://127.0.0.1:8000/editProfile/get_profile/");

      if (response['status'] == 'success') {
        final userData = response['data'];

        setState(() {
          _currentUsername = userData['username'];
          _myReviewsFuture = _fetchMyReviews();
        });
      } else {
        // Tampilkan pesan error jika status tidak sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal memuat data pengguna: ${response['message']}')),
        );
      }
    } catch (e) {
      // Tangani error yang terjadi selama permintaan HTTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMyReviews() async {
    final request = context.read<CookieRequest>();

    if (_currentUsername == null) {
      throw Exception('User not authenticated');
    }

    final url =
        Uri.parse('http://127.0.0.1:8000/review/json/$_currentUsername/');

    final response = await request.get(url.toString());

    if (response["status"] != "success") {
      throw Exception('Failed to load reviews');
    }

    List<dynamic> data = response["data"];
    List<Map<String, dynamic>> detailedReviews = [];

    for (var item in data) {
      FoodReview review = FoodReview.fromJson(item);
      // Fetch food details
      final foodUrl =
          Uri.parse('http://127.0.0.1:8000/review/json/${review.fields.food}/');
      final foodResponse = await request.get(foodUrl.toString());
      if (foodResponse["status"] == "success") {
        Food food = Food.fromJson(foodResponse["data"]);
        detailedReviews.add({
          'review': review,
          'food': food,
        });
      }
      // else {
      //   detailedReviews.add({
      //     'review': review,
      //     'food': Food(id: review.fields.food, namaMakanan: 'Unknown', gambar: ''),
      //   });
      // }
    }

    return detailedReviews;
  }

  void _showEditModal(BuildContext context, Map<String, dynamic> reviewData) {
    final FoodReview review = reviewData['review'];
    final Food food = reviewData['food'];
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
                        Text('Food: ${food.fields.namaMakanan}'),
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
                backgroundColor: Colors.blue, // Menggunakan backgroundColor
                foregroundColor: Colors.white, // Menggunakan foregroundColor
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final request = context.read<CookieRequest>();
                  final editUrl = Uri.parse(
                      'http://127.0.0.1:8000/review/edit/${review.pk}/');

                  final response = await request.post(
                    editUrl.toString(),
                    {
                      'rating': rating.toString(),
                      'review_message': message,
                    },
                  );

                  if (response["status"] == "success") {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Review updated successfully')),
                    );
                    setState(() {
                      _myReviewsFuture = _fetchMyReviews();
                    });
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update review')),
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

  void _deleteReview(int reviewId) async {
    final request = context.read<CookieRequest>();
    final deleteUrl =
        Uri.parse('http://127.0.0.1:8000/review/delete-review/$reviewId/');

    final response = await request.post(
      deleteUrl.toString(),
      {},
    );

    if (response["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully')),
      );
      setState(() {
        _myReviewsFuture = _fetchMyReviews();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _myReviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error state
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Empty state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You haven't reviewed any food yet!",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Start sharing your culinary experiences by adding a review.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to AddReviewPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddReviewPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A017), // backgroundColor
                    foregroundColor: Colors.white, // foregroundColor
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Add Your Review'),
                ),
              ],
            ),
          );
        } else {
          // Data loaded
          List<Map<String, dynamic>> reviews = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _myReviewsFuture = _fetchMyReviews();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final reviewData = reviews[index];
                final FoodReview review = reviewData['review'];
                final Food food = reviewData['food'];

                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.yellow.shade300!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        food.fields.gambar.isNotEmpty
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
                              Text(
                                food.fields.namaMakanan,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${review.fields.rating.toStringAsFixed(1)} / 5',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '"${review.fields.reviewMessage}"',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reviewed by ${review.fields.user} on ${_formatDate(review.fields.createdAt)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Edit and Delete buttons
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        _showEditModal(context, reviewData),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blue, // backgroundColor
                                      foregroundColor:
                                          Colors.white, // foregroundColor
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
                                      backgroundColor:
                                          Colors.red, // backgroundColor
                                      foregroundColor:
                                          Colors.white, // foregroundColor
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

  String _formatDate(DateTime date) {
    // Format date sebagai "d M Y", misalnya "09 Dec 2024"
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

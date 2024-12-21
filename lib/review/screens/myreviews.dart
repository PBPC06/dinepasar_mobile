// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/review/models/review_entry.dart';
import 'package:dinepasar_mobile/review/widgets/addreview.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  late Future<List<FoodReview>> _myReviewsFuture;
  @override
  void initState() {
    super.initState();
    _myReviewsFuture = _fetchMyReviews();
  }

  // Fungsi untuk mengambil ulasan user
  Future<List<FoodReview>> _fetchMyReviews() async {
    final request = context.read<CookieRequest>();
    final response = await request.get("http://127.0.0.1:8000/review/json/");

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
    final formKey = GlobalKey<FormState>();
    double rating = review.fields.rating;
    String message = review.fields.reviewMessage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Review | ${review.fields.namaMakanan}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Food Rating | 1.0 - 5.0'),
                        const SizedBox(height: 10),
                        RatingBar.builder(
                          initialRating: rating.toDouble(),
                          minRating: 1,
                          maxRating: 5,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 45.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating;
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
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(107, 114, 128, 1),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(202, 139, 4, 1),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final request = context.read<CookieRequest>();
                  final editUrl =
                      "http://127.0.0.1:8000/review/edit/${review.pk}/";

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
                      _myReviewsFuture = _fetchMyReviews();
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

  void _confirmDeleteReview(int reviewId) async {
    bool? delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete this review?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion, proceed with the delete action
    if (delete == true) {
      _deleteReview(reviewId);
    }
    setState(() {
      _myReviewsFuture = _fetchMyReviews();
    });
  }

  // Fungsi untuk menghapus ulasan
  void _deleteReview(int reviewId) async {
    final request = context.read<CookieRequest>();
    final deleteUrl =
        "http://127.0.0.1:8000/review/delete-review/$reviewId/"; // Sesuaikan dengan endpoint delete Anda

    await request.post(
      deleteUrl,
      {},
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _myReviewsFuture = _fetchMyReviews();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: FutureBuilder<List<FoodReview>>(
        future: _myReviewsFuture,
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
                "You haven't reviewed any food yet!\nStart sharing your culinary experiences by adding a review.",
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
                  _myReviewsFuture = _fetchMyReviews();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
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
                          review.fields.gambar.isNotEmpty
                              ? Image.network(
                                  review.fields.gambar,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.restaurant,
                                          size: 40, color: Colors.white),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.restaurant,
                                      size: 40, color: Colors.white),
                                ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Menampilkan nama makanan
                                Text(
                                  review.fields.namaMakanan,
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
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${formatRating(review.fields.rating)} / 5.0',
                                      style: TextStyle(
                                          color: Colors.grey.shade800),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Menampilkan pesan ulasan
                                Text(
                                  '"${review.fields.reviewMessage}"',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                                const SizedBox(height: 4),
                                // Menampilkan informasi pengguna dan tanggal ulasan
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 69, 69, 69),
                                      fontSize: 12,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Reviewed by ',
                                      ),
                                      TextSpan(
                                        text: review.fields.user,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' on ${_formatDate(review.fields.createdAt)}',
                                      ),
                                    ],
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
                                        textStyle:
                                            const TextStyle(fontSize: 12),
                                      ),
                                      child: const Text('Edit'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _confirmDeleteReview(review.pk),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        textStyle:
                                            const TextStyle(fontSize: 12),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newReview = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReviewPage()),
          );

          if (newReview != null) {
            setState(() {
              // Tambahkan ulasan baru tanpa memuat ulang seluruh data
              _myReviewsFuture = Future(() async {
                final currentReviews = await _myReviewsFuture;
                currentReviews.add(FoodReview.fromJson(newReview));
                return currentReviews;
              });
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFEFCEC),
      ),
    );
  }

  // Fungsi untuk memformat tanggal
  String _formatDate(DateTime date) {
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

String formatRating(double rating) {
  if (rating == rating.toInt()) {
    return rating.toStringAsFixed(1);
  }
  return '$rating';
}

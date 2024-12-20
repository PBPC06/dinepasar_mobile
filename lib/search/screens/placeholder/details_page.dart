import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final int foodId;

  const DetailsPage({super.key, required this.foodId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? food; // Data makanan
  bool isLoading = true; // Status loading
  String errorMessage = ''; // Pesan error
  bool showFullDescription = false; // Untuk toggle deskripsi

  // Fungsi untuk mengambil data makanan
  Future<void> fetchFoodDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/deskripsi/api/${widget.foodId}/'),
      );
      if (response.statusCode == 200) {
        setState(() {
          food = json.decode(response.body); // Parse JSON ke Map
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load food details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data. Please try again.';
      });
      print('Error: $e');
    }
  }

  // Fungsi untuk membuka URL di browser
  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        foregroundColor: const Color(0xFF242424),
        elevation: 0,
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Color(0xFF242424),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF242424)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : food == null
                  ? const Center(child: Text('No data found.'))
                  : ListView(
                      children: [
                        // Image Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: double.infinity,
                            height: 202,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(16)),
                              image: DecorationImage(
                                image: NetworkImage(food!['gambar'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // Title and Rating
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food!['nama_makanan'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 20,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                food!['kategori'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFA2A2A2),
                                  fontSize: 12,
                                  fontFamily: 'Sora',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${food!['rating'] ?? 0.0} ',
                                          style: const TextStyle(
                                            color: Color(0xFF2A2A2A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFE3E3E3), thickness: 1),
                        const SizedBox(height: 16),
                        // Location Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Location',
                                style: TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 16,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  openUrl(food!['restoran'] ?? '');
                                },
                                child: Text(
                                  food!['restoran'] ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFFFBC02D),
                                    fontSize: 14,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
                                style: TextStyle(
                                  color: Color(0xFF242424),
                                  fontSize: 16,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showFullDescription = !showFullDescription;
                                  });
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: showFullDescription
                                            ? food!['deskripsi']
                                            : (food!['deskripsi'] ?? '')
                                                .substring(0, food!['deskripsi'].length > 116 ? 116 : food!['deskripsi'].length),
                                        style: const TextStyle(
                                          color: Color(0xFFA2A2A2),
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (!showFullDescription && (food!['deskripsi'] ?? '').length > 116)
                                        const TextSpan(
                                          text: '.. Read More',
                                          style: TextStyle(
                                            color: Color(0xFFFBC02D),
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Footer with Price and Buttons
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Color(0xFF909090),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${food!['harga'] ?? 0}',
                                    style: const TextStyle(
                                      color: Color(0xFFFBC02D),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFBC02D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Add to favorite logic
                                    },
                                    child: const Text(
                                      'Add to Favorite',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFBC02D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Add review logic
                                    },
                                    child: const Text(
                                      'Add Review',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
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

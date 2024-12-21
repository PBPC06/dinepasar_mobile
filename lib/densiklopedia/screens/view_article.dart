import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/web_image.dart';

class ViewArticle extends StatelessWidget {
  final Article article;

  const ViewArticle({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 240,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16.0)),
                child: kIsWeb
                    ? WebImage(
                        imageUrl: article.gambar,
                        height: 240,
                        width: double.infinity,
                      )
                    : Image.network(
                        article.gambar,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 240,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          // Content Frame
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        article.judul,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF231F20),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Content
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.2, // Adjust line height for sentences
                            color: Color.fromARGB(255, 33, 30, 31),
                          ),
                          children: _buildParagraphs(article.konten),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  List<TextSpan> _buildParagraphs(String content) {
    final paragraphs = content.split('\n\n');
    return paragraphs.map((paragraph) {
      return TextSpan(
        text: paragraph + '\n\n',
        style: const TextStyle(height: 1.8), // Adjust line height for paragraphs
      );
    }).toList();
  }
}

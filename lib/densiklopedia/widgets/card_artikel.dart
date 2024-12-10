import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';

class ArticleCard extends StatelessWidget {
  final Article article; // Menggunakan model Article
  final VoidCallback onTap; // Callback untuk navigasi
  final VoidCallback onEdit; // Callback untuk tombol edit
  final VoidCallback onDelete; // Callback untuk tombol delete

  const ArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Callback ketika kartu di klik
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                article.gambar,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            // Article Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Title
                  Text(
                    article.judul,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF231F20),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  // Article Subtitle
                  Text(
                    article.subjudul,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF606060),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16.0),
                  // Action Buttons: Edit and Delete
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.brown),
                        onPressed: onEdit,
                      ),
                      const SizedBox(width: 12.0),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.brown),
                        onPressed: onDelete,
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
  }
}
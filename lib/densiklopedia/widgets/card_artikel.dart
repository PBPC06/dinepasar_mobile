import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
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
              // Gambar Artikel
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
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
              // Konten Artikel
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Artikel
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
                    // Subjudul Artikel
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
      ),
    );
  }
}
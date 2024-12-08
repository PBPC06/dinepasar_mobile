import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String author;
  final String date;

  const ArticleCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Margin di sisi luar card
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar card
        borderRadius: BorderRadius.circular(16.0), // Radius untuk seluruh card
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Bayangan untuk estetika
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Artikel
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Radius untuk gambar di bagian atas
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300], // Warna pengganti jika gambar gagal dimuat
                  child: Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
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
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF231F20),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Jika teks terlalu panjang
                ),
                const SizedBox(height: 8.0),
                // Penulis dan Tanggal
                Text(
                  '$author · $date',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF6D6265),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
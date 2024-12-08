import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/article_card.dart';

class ArtikelPage extends StatelessWidget {
  const ArtikelPage({Key? key}) : super(key: key);

  final List<Map<String, String>> articles = const [
    {
      "title": "Contoh Artikel 1",
      "imageUrl": "https://example.com/image1.jpg",
      "author": "Author 1",
      "date": "April 27, 2024",
    },
    // Tambahkan artikel lainnya...
  ];

  @override
  Widget build(BuildContext context){
    return articles.isEmpty 
      ? const Center(child: Text('Belum ada artikel yang tersedia'))
      : ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index){
            final article = articles[index];
            return ArticleCard(
              title: article['title']!,
              imageUrl: article['imageUrl']!,
              author: article['author']!,
              date: article['date']!,
            );
          },
        );
  }
}
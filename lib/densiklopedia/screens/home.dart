import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/category_slider.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/article_card.dart';

class HomePageArticle extends StatelessWidget {
  const HomePageArticle({Key? key}) : super(key: key); // Tambahkan const di sini

  static const List<Map<String, String>> articles = [
    {
      "title": "Profil Denpasar yang Harus Kamu Ketahui",
      "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/f/f8/Aerial_view_of_Bajra_Sandhi_Monument_Denpasar_Bali_Indonesia.jpg",
      "author": "Nyoman Arka",
      "date": "July 15, 2023",
    },
    {
      "title": "Sejarah Denpasar",
      "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/4/40/COLLECTIE_TROPENMUSEUM_Luchtfoto_van_Denpasar_TMnr_10029767.jpg",
      "author": "I Wayan Suyasa",
      "date": "August 20, 2023",
    },
    {
      "title": "Wisata Denpasar",
      "imageUrl": "https://akcdn.detik.net.id/community/media/visual/2019/03/30/0890595d-0b8a-4212-b2a9-934e19f0b58b_169.jpeg?w=700&q=90",
      "author": "Ketut Rai",
      "date": "September 5, 2023",
    },
    {
      "title": "Budaya Denpasar",
      "imageUrl": "https://awsimages.detik.net.id/community/media/visual/2019/06/05/d28786b8-4114-4725-bb39-9fc44ba519d9.jpeg?w=600&q=90",
      "author": "Made Sukanta",
      "date": "October 10, 2023",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Category Slider
          CategorySlider(
            defaultIndex: 0,
            onCategorySelected: (index) {
              // Logic untuk onCategorySelected (opsional, bisa disesuaikan)
            },
          ),
          // Konten berdasarkan kategori
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCard(
                  title: article["title"]!,
                  imageUrl: article["imageUrl"]!,
                  author: article["author"]!,
                  date: article["date"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
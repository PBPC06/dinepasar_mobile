// lib/densiklopedia/screens/artikel.dart

import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/category_slider.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/article_card.dart';

class ArtikelPage extends StatefulWidget {
  @override
  _ArtikelPageState createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  List<Map<String, String>> articles = [
    // Data artikel
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Artikel'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // TODO: Add article logic
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategorySlider(
                defaultIndex: 1,
                onCategorySelected: (index) {
                  if (index == 0) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              ),
            ),
            Expanded(
              child: articles.isEmpty
                  ? Center(child: Text('Belum ada artikel yang tersedia'))
                  : ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleCard(
                          title: article['title']!,
                          imageUrl: article['imageUrl']!,
                          author: article['author']!,
                          date: article['date']!,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/category_slider.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/home.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/artikel.dart';

class DensiklopediaPage extends StatefulWidget {
  const DensiklopediaPage({Key? key}) : super(key: key);

  @override
  _DensiklopediaPageState createState() => _DensiklopediaPageState();
}

class _DensiklopediaPageState extends State<DensiklopediaPage> {
  int _currentIndex = 0; // 0 untuk Home, 1 untuk Artikel

  final List<Widget> _subPages = [
    HomePageArticle(),
    ArtikelPage(),
  ];

  void _onCategorySelected(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false, // Menonaktifkan tombol back perangkat
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CategorySlider(
              defaultIndex: _currentIndex,
              onCategorySelected: _onCategorySelected,
            ),
          ),
          Expanded(
            child: _subPages[_currentIndex],
          ),
        ],
      ),
    );
  }
}
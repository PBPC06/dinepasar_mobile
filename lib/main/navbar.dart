import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/main/screens/homepage.dart';
import 'package:dinepasar_mobile/review/review.dart';
import 'package:dinepasar_mobile/search/screens/explore_page.dart';
import 'package:dinepasar_mobile/search/screens/admin_page.dart';
import 'package:dinepasar_mobile/profile/screens/profile.dart';
import 'package:dinepasar_mobile/densiklopedia/densiklopedia.dart';
import 'package:dinepasar_mobile/favorite/screens/favorite_page.dart'; // Import FavoritePage

class MyHomePage extends StatefulWidget {
  final String userRole;
  const MyHomePage({Key? key, required this.userRole}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const Placeholder(),
    const ReviewPage(),
    const FavoritePage(),
    const DensiklopediaPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchPageContent = widget.userRole == 'admin'
        ? const AdminPage()
        : const ExplorePage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinepasar'),
        backgroundColor: const Color.fromARGB(255, 200, 161, 35),
      ),
      body: _selectedIndex == 1 ? searchPageContent : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Densiklopedia'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

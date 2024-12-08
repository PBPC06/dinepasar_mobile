import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/screens/explore_page.dart';
import 'package:dinepasar_mobile/profile/screens/profile.dart';
import 'package:dinepasar_mobile/densiklopedia/densiklopedia.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = <Widget>[
    const Placeholder(),  // Explore Page
    const ExplorePage(),  // Placeholder for Search Page
    const Placeholder(),  // Placeholder for Review Page
    const Placeholder(),  // Placeholder for Favorite Page
    const DensiklopediaPage(), // Placeholder for Favorite Page
    const ProfilePage(),  // Placeholder for Profile Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinepasar'),
        backgroundColor: Color.fromARGB(255, 200, 161, 35),
      ),
      body: _pages[_selectedIndex],  // Show the selected page from the _pages list
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Set the current selected tab
        onTap: _onItemTapped,  // Handle tab switch
        selectedItemColor: Colors.yellow[700],  // Highlight color for the selected item
        unselectedItemColor: Colors.grey,  // Set the color of unselected items to grey
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Densiklopedia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

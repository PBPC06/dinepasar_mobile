import 'package:dinepasar_mobile/main/screens/homepage.dart';
import 'package:dinepasar_mobile/review/review.dart';
import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/screens/explore_page.dart';
import 'package:dinepasar_mobile/search/screens/admin_page.dart';
import 'package:dinepasar_mobile/profile/screens/profile.dart';
import 'package:dinepasar_mobile/densiklopedia/densiklopedia.dart';

class MyHomePage extends StatefulWidget {
  final String userRole; // Menyimpan role user: "admin" atau "user"
  const MyHomePage({Key? key, required this.userRole}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Declare a list of pages that correspond to each tab
  final List<Widget> _pages = <Widget>[
    const HomePage(), // Home Page
    const Placeholder(), // Placeholder for conditional Search Page
    const ReviewPage(),  // Review Page
    const Placeholder(), // Favorite Page
    const DensiklopediaPage(), // Densiklopedia Page
    const ProfilePage(), // Profile Page
  ];

  // Method to switch pages when a tab is clicked
  void _onItemTapped(int index) {
    if (index == 1) { // If 'Search' is selected
      setState(() {
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Conditional display based on user role for the 'Search' tab
    Widget searchPageContent;
    if (widget.userRole == 'admin') {
      searchPageContent = const AdminPage(); // Show AdminPage for admin
    } else {
      searchPageContent = const ExplorePage(); // Show ExplorePage for regular user
    }

    return Scaffold(
    // appBar: AppBar(
    //   title: Text(
    //     'Dinepasar',
    //     style: TextStyle(
    //       color: Color.fromRGBO(202, 138, 4, 1), // Warna teks
    //       fontSize: 28, // Ukuran font
    //       fontWeight: FontWeight.w600, // Ketebalan font (semi-bold)
    //       fontStyle: FontStyle.normal, // Gaya font (normal/italic)
    //     ),
    //   ),
    //   centerTitle: true, // Teks berada di tengah
    //   backgroundColor: const Color.fromRGBO(254, 252, 233, 1), // Warna latar belakang
    // ),
      body: _selectedIndex == 1
          ? searchPageContent // Display appropriate search page based on role
          : _pages[_selectedIndex], // Display other pages based on tab selection
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Colors.grey,
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

import 'package:dinepasar_mobile/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/screens/menu.dart';
// import 'package:food_pedia/screens/foodentry_form.dart';
// import 'package:food_pedia/screens/list_foodentry.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // Bagian drawer header
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 206, 62),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Dinepasar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      color: Color.fromARGB(255, 34, 34, 34),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Explore the taste of Denpasar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
          ),
            // Bagian routing
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(), // Route to FoodEntryFormPage
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
              //     // Route menu ke halaman mood
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => const FoodEntryPage()),
              //     );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorite'),
              onTap: () {
              //     // Route menu ke halaman mood
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => const FoodEntryPage()),
              //     );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text('Review'),
              onTap: () {
                  // Route menu ke halaman mood
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => const FoodEntryPage()),
              //     );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Dinepasar'),
              onTap: () {
              //     // Route menu ke halaman mood
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => const FoodEntryPage()),
              //     );
              },
            ),
        ],
      ),
    );
  }
}
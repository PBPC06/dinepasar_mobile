import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dinepasar_mobile/main/widgets/gapura.dart';
import 'package:dinepasar_mobile/main/widgets/foodgallery.dart';
import 'package:dinepasar_mobile/main/widgets/whydinepasar.dart';
import 'package:dinepasar_mobile/main/widgets/welcome_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = "User";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeSection(username: _username),
                  SizedBox(height: screenHeight * 0.01), // Jarak antar elemen
                  FoodGallerySection(),
                  SizedBox(height: screenHeight * 0.03),
                  WhyDinepasarSection(),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
          const GapuraSection(), // Gapura di bagian bawah
        ],
      ),
    );
  }
}

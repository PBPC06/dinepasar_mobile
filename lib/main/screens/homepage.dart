import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dinepasar_mobile/main/widgets/welcome_section.dart';
import 'package:dinepasar_mobile/main/widgets/foodgallery.dart';
import 'package:dinepasar_mobile/main/widgets/personalized.dart';
import 'package:dinepasar_mobile/main/widgets/whydinepasar.dart';
import 'package:dinepasar_mobile/main/widgets/threesteps.dart';
import 'package:dinepasar_mobile/main/widgets/densiklopedia_preview.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 241, 226, 1), // Warna background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSection(username: _username),
            FoodGallerySection(),
            PersonalizedSection(),
            WhyDinepasarSection(),
            ThreeStepsSection(),
            DensiklopediaPreviewSection(),
          ],
        ),
      ),
    );
  }
}

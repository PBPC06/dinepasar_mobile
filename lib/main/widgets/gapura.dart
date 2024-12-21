import 'package:flutter/material.dart';

class GapuraSection extends StatelessWidget {
  const GapuraSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.3, // Menyesuaikan tinggi berdasarkan layar
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'lib/main/assets/left_gapura.png', // Gambar gapura kiri
              height: screenHeight * 0.2, // Tinggi gambar responsif
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'lib/main/assets/right_gapura.png', // Gambar gapura kanan
              height: screenHeight * 0.2, // Tinggi gambar responsif
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 1.0), // Jarak teks ke bawah
              child: Text(
                "Dive into A Culinary Adventure\nin Denpasar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, // Font responsif
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color.fromRGBO(202, 138, 4, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/card_home.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/home/profil.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/home/sejarah.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/home/wisata.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/home/budaya.dart';

class HomePageArticle extends StatelessWidget {
  HomePageArticle({super.key});

  final List<Article> articles = [
    Article(
      id: "1",
      judul: "Profil Denpasar yang Harus Kamu Ketahui",
      gambar: "https://upload.wikimedia.org/wikipedia/commons/f/f8/Aerial_view_of_Bajra_Sandhi_Monument_Denpasar_Bali_Indonesia.jpg",
      subjudul: "Temukan berbagai informasi menarik tentang Denpasar, ibukota Bali.",
      konten: "",
    ),
    Article(
      id: "2",
      judul: "Sejarah Denpasar dan Leluhurnya",
      gambar: "https://upload.wikimedia.org/wikipedia/commons/4/40/COLLECTIE_TROPENMUSEUM_Luchtfoto_van_Denpasar_TMnr_10029767.jpg",
      subjudul: "Menyelami sejarah panjang dan leluhur Denpasar yang kaya.",
      konten: "",
    ),
    Article(
      id: "3",
      judul: "Wisata Seru yang Wajib Dikunjungi di Denpasar",
      gambar: "https://akcdn.detik.net.id/community/media/visual/2019/03/30/0890595d-0b8a-4212-b2a9-934e19f0b58b_169.jpeg?w=700&q=90",
      subjudul: "Jelajahi tempat-tempat wisata menarik yang harus dikunjungi di Denpasar.",
      konten: "",
    ),
    Article(
      id: "4",
      judul: "Budaya Indah Ala Denpasar",
      gambar: "https://awsimages.detik.net.id/community/media/visual/2019/06/05/d28786b8-4114-4725-bb39-9fc44ba519d9.jpeg?w=600&q=90",
      subjudul: "Nikmati keindahan budaya Denpasar yang memikat.",
      konten: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return HomeCard(
            article: article,
            onTap: () {
              // Navigate to the corresponding screen based on the article ID
              switch (article.id) {
                case "1":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilPage()),
                  );
                  break;
                case "2":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SejarahPage()),
                  );
                  break;
                case "3":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WisataPage()),
                  );
                  break;
                case "4":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BudayaPage()),
                  );
                  break;
                default:
                  // Show an error or navigate to a default page if the ID is unknown
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Artikel tidak ditemukan')),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/view_article.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';

class WisataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final article = Article(
      id: "3",
      judul: "Wisata Seru yang Wajib Dikunjungi di Denpasar",
      gambar: "https://akcdn.detik.net.id/community/media/visual/2019/03/30/0890595d-0b8a-4212-b2a9-934e19f0b58b_169.jpeg?w=700&q=90",
      subjudul: "Jelajahi tempat-tempat wisata menarik yang harus dikunjungi di Denpasar.",
      konten: """
      Denpasar, ibu kota Provinsi Bali, menawarkan beragam destinasi wisata yang memikat hati wisatawan lokal maupun mancanegara. Sebagai pusat aktivitas budaya, sejarah, dan ekonomi, Denpasar menjadi tempat yang sempurna untuk mengeksplorasi keindahan alam sekaligus merasakan kehidupan masyarakat Bali yang autentik. Berbagai objek wisata menarik tersedia di sini, mulai dari pantai yang indah hingga monumen bersejarah yang sarat makna.

      Salah satu destinasi wisata favorit di Denpasar adalah Monumen Bajra Sandhi. Monumen ini merupakan simbol perjuangan rakyat Bali melawan penjajahan, dengan desain arsitektur unik yang mencerminkan budaya Bali. Di dalamnya, terdapat museum yang memamerkan diorama tentang sejarah perjuangan rakyat Bali, menjadikannya tempat yang tidak hanya indah untuk dilihat tetapi juga kaya akan nilai edukasi.

      Untuk wisatawan yang menyukai suasana pantai, Pantai Sanur adalah pilihan terbaik. Pantai ini menawarkan pemandangan matahari terbit yang memukau, lengkap dengan pasir putih dan air laut yang tenang. Sanur juga dikenal dengan jalur pesisirnya yang cocok untuk berjalan-jalan santai atau bersepeda. Di sepanjang pantai, terdapat banyak restoran dan kafe yang menyajikan hidangan lokal maupun internasional, memberikan pengalaman kuliner yang menyenangkan.

      Selain itu, Pasar Badung adalah tempat yang wajib dikunjungi untuk merasakan kehidupan lokal masyarakat Denpasar. Sebagai pasar tradisional terbesar di Bali, Pasar Badung menawarkan berbagai macam produk, mulai dari hasil bumi segar, bumbu khas Bali, hingga kerajinan tangan seperti kain tenun dan ukiran kayu. Pasar ini tidak hanya menjadi tempat berbelanja, tetapi juga memperlihatkan dinamika budaya masyarakat Bali dalam kehidupan sehari-hari.

      Bagi pecinta seni dan sejarah, Museum Bali adalah tempat yang ideal. Museum ini menyimpan berbagai koleksi seni dan artefak tradisional Bali, mulai dari alat-alat upacara adat hingga karya seni rupa yang indah. Dengan suasana yang tenang dan penuh keindahan, museum ini menjadi tempat yang tepat untuk memahami lebih dalam tentang warisan budaya Bali.

      Denpasar juga menyuguhkan wisata kuliner yang tak kalah menarik. Hidangan khas seperti Ayam Betutu, Babi Guling, dan Lawar menjadi incaran para wisatawan yang ingin mencicipi cita rasa autentik Bali. Setelah menjelajahi kota, Anda juga bisa bersantai dengan menikmati segelas kopi Bali yang terkenal akan aroma dan rasanya yang khas. Dengan berbagai pilihan destinasi dan pengalaman unik yang ditawarkan, Denpasar benar-benar menjadi destinasi wisata yang tak boleh dilewatkan.
      """
    );

    return ViewArticle(article: article);
  }
}
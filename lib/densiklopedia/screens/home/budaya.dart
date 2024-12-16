import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/view_article.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';

class BudayaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final article = Article(
      id: "4", 
      judul: "Budaya Indah Ala Denpasar",
      gambar: "https://awsimages.detik.net.id/community/media/visual/2019/06/05/d28786b8-4114-4725-bb39-9fc44ba519d9.jpeg?w=600&q=90",
      subjudul: "Nikmati keindahan budaya Denpasar yang memikat.",
      konten: """
      Denpasar, ibu kota Provinsi Bali, dikenal dengan budayanya yang kaya dan mempesona. Budaya Bali yang kental sangat terasa di Denpasar, mulai dari seni tari, upacara adat, hingga seni rupa yang menggambarkan kehidupan sehari-hari masyarakat Bali. Tidak hanya itu, masyarakat Denpasar juga memegang teguh nilai-nilai leluhur mereka, yang tercermin dalam cara mereka menjaga tradisi budaya dan keagamaan di tengah modernisasi yang semakin pesat. Kota ini menjadi contoh harmoni antara kehidupan tradisional dan kemajuan zaman.

      Seni tari tradisional Bali menjadi salah satu elemen penting dalam budaya Denpasar. Tarian-tarian seperti Tari Kecak, Legong, dan Barong bukan hanya menjadi hiburan tetapi juga sarat dengan makna filosofis yang mendalam. Setiap gerakan dalam tarian memiliki cerita yang menceritakan kisah mitologi Hindu atau pengabdian kepada para dewa. Pentas seni tari ini sering dilakukan pada upacara adat, ritual keagamaan, atau saat menyambut tamu penting, menjadikannya bagian integral dari kehidupan sehari-hari masyarakat Denpasar.

      Tradisi unik seperti Ngaben dan Odalan menjadi daya tarik tersendiri bagi wisatawan lokal maupun mancanegara. Ngaben, upacara kremasi khas Bali, merupakan salah satu ritual keagamaan yang paling penting. Melalui upacara ini, roh almarhum dipercaya akan dilepaskan dari dunia fana untuk menuju alam keabadian. Sementara itu, Odalan, yaitu perayaan ulang tahun pura, dilakukan dengan meriah melalui tarian, musik gamelan, dan persembahan yang indah. Tradisi ini tidak hanya menjadi bentuk penghormatan kepada para leluhur tetapi juga menjadi atraksi budaya yang menggugah hati para wisatawan.

      Kerajinan tangan masyarakat Denpasar juga menjadi salah satu kekayaan budaya yang tak ternilai. Dari ukiran kayu yang rumit hingga tenun ikat dengan pola tradisional, produk-produk ini tidak hanya diminati di Bali tetapi juga diekspor ke berbagai negara. Kerajinan tangan ini menunjukkan kreativitas dan keahlian masyarakat lokal yang diwariskan dari generasi ke generasi. Selain itu, pasar seni di Denpasar seperti Pasar Badung dan Pasar Kumbasari menjadi tempat favorit untuk menemukan hasil kerajinan ini.

      Budaya kuliner Denpasar juga tak kalah menarik untuk dieksplorasi. Hidangan khas seperti Babi Guling, Ayam Betutu, dan lawar menjadi favorit para wisatawan yang ingin mencicipi cita rasa otentik Bali. Setiap makanan memiliki cerita dan filosofi tersendiri yang berkaitan dengan tradisi dan kepercayaan masyarakat. Tak hanya makanan, tradisi minum jamu dan kopi Bali di pagi hari juga menjadi bagian dari budaya yang mempererat hubungan sosial antarwarga. Dengan beragam keunikan yang ditawarkan, Denpasar benar-benar menjadi destinasi yang kaya akan nilai budaya dan spiritualitas.
      """,
    );

    return ViewArticle(article: article);
  }
}
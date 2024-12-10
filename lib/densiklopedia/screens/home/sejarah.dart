import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/view_article.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';

class SejarahPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final article = Article(
      id: "2",
      judul: "Sejarah Denpasar dan Leluhurnya",
      gambar: "https://upload.wikimedia.org/wikipedia/commons/4/40/COLLECTIE_TROPENMUSEUM_Luchtfoto_van_Denpasar_TMnr_10029767.jpg",
      subjudul: "Menyelami sejarah panjang dan leluhur Denpasar yang kaya.",
      konten: """
      Denpasar, sebagai ibu kota Provinsi Bali, memiliki sejarah yang kaya dan menarik untuk ditelusuri. Kota ini tidak hanya menjadi pusat pemerintahan dan ekonomi, tetapi juga merupakan tempat di mana tradisi dan budaya Bali berkembang dan dilestarikan selama berabad-abad. Perjalanan sejarah Denpasar menunjukkan bagaimana kota ini bertransformasi dari pusat kerajaan kecil menjadi ibu kota modern yang dinamis.

      Pada masa lalu, Denpasar merupakan bagian dari Kerajaan Badung yang berpusat di Puri Pemecutan. Nama Denpasar sendiri berasal dari istilah "den" yang berarti utara dan "pasar" yang merujuk pada pasar tradisional yang menjadi pusat aktivitas ekonomi dan sosial masyarakat. Denpasar mulai dikenal secara luas pada abad ke-19, ketika Kerajaan Badung menjadi salah satu kekuatan yang penting di Bali. Namun, kedatangan kolonial Belanda pada akhir abad ke-19 membawa babak baru dalam sejarah Denpasar.

      Salah satu peristiwa penting dalam sejarah Denpasar adalah Perang Puputan Badung pada tahun 1906. Perang ini menjadi simbol perlawanan rakyat Bali terhadap kolonialisme Belanda. Meskipun pasukan Kerajaan Badung mengalami kekalahan, semangat perjuangan mereka tetap hidup dalam ingatan masyarakat Bali hingga kini. Peristiwa ini juga diabadikan dalam Monumen Puputan Badung yang berdiri di tengah kota sebagai penghormatan terhadap para pahlawan yang gugur.

      Setelah Bali menjadi bagian dari Republik Indonesia, Denpasar mengalami perkembangan pesat sebagai pusat pemerintahan, perdagangan, dan pariwisata. Pada tahun 1958, Denpasar resmi ditetapkan sebagai ibu kota Provinsi Bali, menggantikan Singaraja yang sebelumnya memegang peran tersebut. Sejak saat itu, Denpasar berkembang menjadi kota modern tanpa melupakan akar budayanya. Berbagai monumen, pura, dan tempat bersejarah di kota ini tetap dijaga dengan baik sebagai simbol identitas dan warisan leluhur.

      Hingga saat ini, Denpasar tetap mempertahankan keunikan sejarahnya melalui pelestarian tradisi dan budaya. Berbagai kegiatan adat, seperti upacara Odalan dan Ngaben, masih sering dilakukan di Pura-pura yang tersebar di seluruh penjuru kota. Sejarah panjang Denpasar tidak hanya memberikan wawasan tentang masa lalu, tetapi juga memperkaya identitas kota ini sebagai pusat kebudayaan Bali yang terus berkembang. Bagi para wisatawan dan peneliti sejarah, Denpasar menjadi tempat yang menarik untuk mempelajari perjalanan peradaban Bali dari masa ke masa.
      """,
    );

    return ViewArticle(article: article);
  }
}
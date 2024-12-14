import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/view_article.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final article = Article(
      id: "1",
      judul: "Profil Denpasar yang Harus Kamu Ketahui",
      gambar: "https://upload.wikimedia.org/wikipedia/commons/f/f8/Aerial_view_of_Bajra_Sandhi_Monument_Denpasar_Bali_Indonesia.jpg",
      subjudul: "Temukan berbagai informasi menarik tentang Denpasar, ibukota Bali.",
      konten: """
      Denpasar, ibu kota Provinsi Bali, merupakan pusat pemerintahan, budaya, dan ekonomi di pulau dewata. Terletak strategis di bagian selatan Bali, Denpasar menjadi pintu gerbang utama bagi wisatawan domestik maupun mancanegara yang ingin menjelajahi keindahan alam dan budaya Bali. Kota ini memadukan perkembangan modern dengan kekayaan tradisi yang tetap terjaga, menjadikannya sebagai pusat dinamika kehidupan masyarakat Bali.

      Sebagai kota metropolitan, Denpasar dikenal dengan fasilitas infrastrukturnya yang terus berkembang. Jalan-jalan utama seperti Jalan Gajah Mada dan Jalan Sudirman menjadi pusat aktivitas ekonomi, perdagangan, dan bisnis. Denpasar juga memiliki Bandara Internasional Ngurah Rai yang menjadi salah satu bandara tersibuk di Indonesia. Meskipun modernisasi terus berkembang, Denpasar tetap mempertahankan nuansa tradisionalnya melalui pasar-pasar tradisional seperti Pasar Badung dan Pasar Kumbasari, di mana pengunjung dapat menemukan berbagai hasil kerajinan dan kuliner khas Bali.

      Dari segi budaya, Denpasar adalah rumah bagi berbagai warisan seni dan tradisi. Banyak pura yang tersebar di kota ini, seperti Pura Jagatnatha, yang menjadi pusat spiritual masyarakat Hindu Bali. Upacara keagamaan seperti Odalan sering digelar di pura-pura ini, memperlihatkan kekayaan adat istiadat yang telah diwariskan secara turun-temurun. Selain itu, seni tari dan musik tradisional, seperti Tari Legong dan gamelan Bali, sering dipentaskan di berbagai acara kebudayaan di Denpasar.

      Kota ini juga memiliki beberapa destinasi wisata yang menarik, seperti Monumen Bajra Sandhi yang menggambarkan perjuangan rakyat Bali, serta Museum Bali yang menyimpan koleksi artefak sejarah dan budaya. Bagi pecinta seni, Denpasar menawarkan galeri seni dan pusat pameran yang memamerkan karya seniman lokal dan internasional.

      Dari sisi demografi, Denpasar adalah kota multikultural dengan penduduk yang berasal dari berbagai suku dan agama. Masyarakat Denpasar hidup harmonis dalam keberagaman, menjadikan kota ini sebagai contoh toleransi dan keberagaman budaya di Indonesia. Kehidupan masyarakat yang ramah dan terbuka menciptakan suasana yang hangat bagi para pendatang dan wisatawan.

      Dengan segala keistimewaannya, Denpasar bukan hanya menjadi pusat administrasi dan ekonomi, tetapi juga simbol keberlanjutan budaya Bali di tengah arus globalisasi. Kota ini terus berkembang menjadi kota modern yang tetap menghormati akar budayanya, menjadikannya sebagai tempat yang menarik untuk dijelajahi, baik untuk tujuan wisata, bisnis, maupun kehidupan sehari-hari.
      """,
    );

    return ViewArticle(article: article);
  }
}
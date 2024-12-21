class FoodItem {
  final int id; // ID dari Food
  final String namaMakanan;
  final String gambar;
  final String kategori;
  final int harga;
  final double rating;

  FoodItem({
    required this.id,
    required this.namaMakanan,
    required this.gambar,
    required this.kategori,
    required this.harga,
    required this.rating,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? 0, // Berikan default value jika null
      namaMakanan: json['nama_makanan'] ?? 'Unknown',
      gambar: json['gambar'] ?? '', // Gambar default kosong jika null
      kategori: json['kategori'] ?? 'Unknown',
      harga: json['harga'] ?? 0, // Harga default 0 jika null
      rating: (json['rating'] ?? 0).toDouble(), // Rating default 0.0 jika null
    );
  }
}

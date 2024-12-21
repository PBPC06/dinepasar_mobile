class FoodItem {
  final int id;
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
      id: json['id'] ?? 0,
      namaMakanan: json['nama_makanan'] ?? 'Unknown',
      gambar: json['gambar'] ?? '',
      kategori: json['kategori'] ?? 'Unknown',
      harga: json['harga'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}

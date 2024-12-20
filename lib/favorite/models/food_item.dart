class FoodItem {
  final String model;
  final int pk;
  final Fields fields;

  FoodItem({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      model: json['model'] ?? 'Unknown', // Default value untuk mencegah null
      pk: json['pk'] ?? 0, // Default value
      fields: Fields.fromJson(json['fields'] ?? {}),
    );
  }
}

class Fields {
  final String namaMakanan;
  final String restoran;
  final String kategori;
  final String gambar;
  final String deskripsi;
  final int harga;
  final double rating;

  Fields({
    required this.namaMakanan,
    required this.restoran,
    required this.kategori,
    required this.gambar,
    required this.deskripsi,
    required this.harga,
    required this.rating,
  });

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      namaMakanan: json['nama_makanan'] ?? 'Unknown', // Default value
      restoran: json['restoran'] ?? 'Unknown', // Default value
      kategori: json['kategori'] ?? 'Unknown', // Default value
      gambar: json['gambar'] ?? '', // Default value
      deskripsi: json['deskripsi'] ?? '', // Default value
      harga: json['harga'] ?? 0, // Default value
      rating: json['rating'] != null
          ? (json['rating'] is int
              ? (json['rating'] as int).toDouble()
              : (json['rating'] as double))
          : 0.0, // Default value
    );
  }
}

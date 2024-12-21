import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';

class AdminFoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onApprove; // Fungsi untuk tombol centang
  final VoidCallback onMore; // Fungsi untuk tombol more
  final VoidCallback onEdit; // Fungsi untuk tombol Edit
  final VoidCallback onDelete; // Fungsi untuk tombol Hapus

  const AdminFoodCard({
    super.key,
    required this.food,
    required this.onApprove,
    required this.onMore,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0), // Menambahkan margin agar card tidak terlalu mepet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar makanan
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: food.fields.gambar.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.restaurant,  // Ganti dengan icon sendok dan garpu
                        size: 48,
                        color: Colors.grey,  // Warna icon sesuai tema
                      ),
                    )
                  : Image.network(
                      food.fields.gambar,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.restaurant,  // Ganti dengan icon sendok dan garpu
                            size: 48,
                            color: Colors.grey,  // Warna icon sesuai tema
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Konten bagian bawah
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama makanan
                Text(
                  food.fields.namaMakanan,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Harga makanan
                Text(
                  'Rp ${food.fields.harga.toString()}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black),
                ),
                const SizedBox(height: 4),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      food.fields.rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Deskripsi
                Text(
                  food.fields.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                // Bagian Tombol Centang, More, Edit, dan Hapus
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Centang (Approve)
                      InkWell(
                        onTap: onApprove,
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(202, 138, 4, 1), // Warna tombol Approve
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.white, // Ubah warna ikon jika diperlukan
                          ),
                        ),
                      ),

                      // Tombol Hapus (Delete)
                      InkWell(
                        onTap: onDelete,
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(202, 138, 4, 1), // Warna tombol Delete
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.white, // Ubah warna ikon jika diperlukan
                          ),
                        ),
                      ),

                      // Tombol Edit
                      InkWell(
                        onTap: onEdit,
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(202, 138, 4, 1), // Warna tombol Edit
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white, // Ubah warna ikon jika diperlukan
                          ),
                        ),
                      ),

                      // Tombol More
                      InkWell(
                        onTap: onMore,
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(202, 138, 4, 1), // Warna tombol More
                          ),
                          child: const Icon(
                            Icons.more_horiz,
                            size: 20,
                            color: Colors.white, // Ubah warna ikon jika diperlukan
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

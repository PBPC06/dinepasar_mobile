import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Definisi variabel untuk menyimpan input form
  String _namaMakanan = ""; // Untuk menyimpan nama produk
  String _restoran = ""; // Untuk menyimpan nama restoran
  String _kategori = ""; // Untuk menyimpan kategori makanan/minuman
  String _gambar = ""; // Untuk menyimpan URL gambar produk
  String _deskripsi = ""; // Untuk menyimpan deskripsi produk
  int _harga = 0; // Untuk menyimpan harga produk
  double _rating = 0.0; // Untuk menyimpan jumlah stok produk

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TAMBAH MAKANAN',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Membuat teks tebal
              fontSize: 22, // Ukuran font lebih besar
              letterSpacing:
                  1.5, // Spasi antar huruf untuk memberi efek estetik
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(
            255, 238, 169, 100), // Menggunakan warna kuning halus
        foregroundColor: Color.fromRGBO(202, 138, 4, 100),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                    height: 20), // Memberikan jarak lebih untuk estetika
                buildFormField(
                  label: "Nama Makanan/Minuman",
                  hint: "Nama Produk",
                  onChanged: (String? value) => setState(() {
                    _namaMakanan = value!;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama produk tidak boleh kosong!";
                    } else if (value.length < 3) {
                      return "Nama produk harus memiliki setidaknya 3 karakter!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                buildFormField(
                  label: "URL Restoran",
                  hint: "Link URL Restoran",
                  onChanged: (String? value) => setState(() {
                    _restoran = value!;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL restoran tidak boleh kosong!";
                    }

                    // Menggunakan Uri.parse untuk validasi dasar URL
                    final uri = Uri.tryParse(value);
                    if (uri == null ||
                        !uri.hasScheme ||
                        (uri.scheme != 'https' && uri.scheme != 'http')) {
                      return "URL tidak valid! Pastikan menggunakan format HTTP atau HTTPS.";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                buildFormField(
                  label: "Kategori",
                  hint: "Kategori",
                  onChanged: (String? value) => setState(() {
                    _kategori = value!;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Kategori tidak boleh kosong!";
                    } else if (value.length < 3) {
                      return "Kategori harus memiliki setidaknya 3 karakter!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                buildFormField(
                  label: "Gambar Produk",
                  hint: "Link URL Gambar Produk",
                  onChanged: (String? value) => setState(() {
                    _gambar = value!;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL gambar tidak boleh kosong!";
                    }

                    // Menggunakan Uri.parse untuk validasi dasar URL
                    final uri = Uri.tryParse(value);
                    if (uri == null ||
                        !uri.hasScheme ||
                        (uri.scheme != 'http' && uri.scheme != 'https')) {
                      return "URL tidak valid! Pastikan menggunakan format HTTP atau HTTPS.";
                    }

                    // Memastikan ekstensi file yang valid untuk gambar
                    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
                    if (!imageExtensions
                        .any((ext) => value.toLowerCase().endsWith(ext))) {
                      return "URL harus mengarah ke gambar (.jpg, .jpeg, .png, .gif).";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),
                buildFormField(
                  label: "Deskripsi",
                  hint: "Deskripsi",
                  maxLines: 3, // Agar input field lebih besar untuk deskripsi
                  onChanged: (String? value) => setState(() {
                    _deskripsi = value!;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    } else if (value.length < 10) {
                      return "Deskripsi harus memiliki setidaknya 10 karakter!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                buildFormField(
                  label: "Harga",
                  hint: "Harga",
                  onChanged: (String? value) => setState(() {
                    _harga = int.tryParse(value!) ?? 0;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Harga tidak boleh kosong!";
                    }
                    final int? harga = int.tryParse(value);
                    if (harga == null || harga <= 0) {
                      return "Harga harus berupa angka positif!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                buildFormField(
                  label: "Rating (1 - 5)",
                  hint: "Rating",
                  onChanged: (String? value) => setState(() {
                    // Ubah menjadi double dan atur rating, dengan default 0.0 jika parsing gagal
                    _rating = double.tryParse(value ?? '0.0') ?? 0.0;
                  }),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating tidak boleh kosong!";
                    }

                    // Parsing menjadi double
                    final double? rating = double.tryParse(value);
                    if (rating == null || rating < 1.0 || rating > 5.0) {
                      return "Rating harus antara 1.0 hingga 5.0!";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          // final request = Provider.of<CookieRequest>(context, listen: false);
                          final response = await request.post(
                            "http://127.0.0.1:8000/search/add-flutter/",
                            jsonEncode(<String, String>{
                              'nama_makanan': _namaMakanan,
                              'restoran': _restoran,
                              'kategori': _kategori,
                              'gambar': _gambar,
                              'deskripsi': _deskripsi,
                              'harga': _harga.toString(),
                              'rating': _rating.toString(),
                            }),
                          );
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Food baru berhasil disimpan!"),
                              ));
                              Navigator.pop(context, true);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Terdapat kesalahan, silakan coba lagi."),
                              ));
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacer di bagian bawah
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun field form
  Widget buildFormField({
    required String label,
    required String hint,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: 16, color: Colors.grey[800]),
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

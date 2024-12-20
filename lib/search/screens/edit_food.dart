import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditFoodPage extends StatefulWidget {
  final int foodId; // ID untuk makanan yang ingin diedit

  const EditFoodPage({super.key, required this.foodId});

  @override
  _EditFoodPageState createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final _formKey = GlobalKey<FormState>();

  // Variabel untuk menyimpan data form
  String _namaMakanan = "";
  String _restoran = "";
  String _kategori = "";
  String _gambar = "";
  String _deskripsi = "";
  int _harga = 0;
  double _rating = 0.0;

  bool isLoading = true; // Variabel untuk menangani status loading

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFoodData();
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final request = context.read<CookieRequest>();
      final updatedData = {
        'nama_makanan': _namaMakanan,
        'restoran': _restoran,
        'kategori': _kategori,
        'gambar': _gambar,
        'deskripsi': _deskripsi,
        'harga': _harga.toString(),
        'rating': _rating.toString(),
      };

      try {
        final response = await request.post(
          // "https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/search/edit-flutter/${widget.foodId}/",
          "http://127.0.0.1:8000/search/edit-flutter/${widget.foodId}/",
          jsonEncode(updatedData),
        );

        if (response['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Data berhasil diperbarui!'),
          ));
          Navigator.pop(context, updatedData); // Return updated data ke halaman sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Gagal memperbarui data: ${response['message']}'),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating data: $e'),
        ));
      }
    }
  }

  Future<void> _fetchFoodData() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        // "https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/search/edit-flutter/${widget.foodId}/",
        "http://127.0.0.1:8000/search/edit-flutter/${widget.foodId}/",
      );
      

      if (response['status'] == true) {
        final data = response['data'];
        setState(() {
          _namaMakanan = data['nama_makanan'];
          _restoran = data['restoran'];
          _kategori = data['kategori'];
          _gambar = data['gambar'];
          _deskripsi = data['deskripsi'];
          _harga = data['harga'];
          _rating = data['rating'].toDouble();
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch food data: ${response['message']}'),
        ));
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error fetching food data: $e'),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>(); // Langsung gunakan context.watch di build

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Makanan'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                     // Field Nama Makanan
                    buildFormField(
                      label: "Nama Makanan/Minuman",
                      hint: "Nama Produk",
                      initialValue: _namaMakanan,
                      onChanged: (value) => setState(() {
                        _namaMakanan = value!;
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama produk tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    // Field Restoran
                    buildFormField(
                      label: "URL Restoran",
                      hint: "Link URL Restoran",
                      initialValue: _restoran,
                      onChanged: (String? value) => setState(() {
                        _restoran = value!;
                      }),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "URL restoran tidak boleh kosong!";
                        }

                        // Validasi dasar dengan Uri.parse
                        final uri = Uri.tryParse(value);
                        if (uri == null || !uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
                          return "URL tidak valid! Pastikan menggunakan format HTTP atau HTTPS.";
                        }

                        return null;
                      },
                    ),

                    // Field Kategori
                    buildFormField(
                      label: "Kategori",
                      hint: "Kategori",
                      initialValue: _kategori,
                      onChanged: (value) => setState(() {
                        _kategori = value!;
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kategori tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    
                    // Field Gambar
                    buildFormField(
                      label: "Gambar Produk",
                      hint: "Link URL Gambar Produk",
                      initialValue: _gambar,
                      onChanged: (String? value) => setState(() {
                        _gambar = value!;
                      }),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "URL gambar tidak boleh kosong!";
                        }

                        // Validasi URL dasar
                        final uri = Uri.tryParse(value);
                        if (uri == null || !uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
                          return "URL tidak valid! Pastikan menggunakan format HTTP atau HTTPS.";
                        }

                        // Memastikan ekstensi file gambar yang valid
                        final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
                        if (!imageExtensions.any((ext) => value.toLowerCase().endsWith(ext))) {
                          return "URL harus mengarah ke gambar (.jpg, .jpeg, .png, .gif).";
                        }

                        return null;
                      },
                    ),

                    // Field Deskripsi
                    buildFormField(
                      label: "Deskripsi",
                      hint: "Deskripsi",
                      initialValue: _deskripsi,
                      maxLines: 3,
                      onChanged: (value) => setState(() {
                        _deskripsi = value!;
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Deskripsi tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    // Field Harga
                    buildFormField(
                      label: "Harga",
                      hint: "Harga",
                      initialValue: _harga.toString(),
                      onChanged: (String? value) => setState(() {
                        _harga = int.tryParse(value!) ?? 0;
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Harga tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),

                    // Field Rating
                    buildFormField(
                      label: "Rating (1 - 5)", 
                      hint: "Rating",
                      initialValue: _rating.toString(),  // Set initial value to _rating
                      onChanged: (String? value) => setState(() {
                        // Parse the input as a double and update the rating, defaulting to 0.0 if parsing fails
                        _rating = double.tryParse(value ?? '0.0') ?? 0.0;
                      }),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Rating tidak boleh kosong!";
                        }

                        // Parsing the value to double
                        final double? rating = double.tryParse(value);
                        if (rating == null || rating < 1.0 || rating > 5.0) {
                          return "Rating harus antara 1.0 hingga 5.0!";
                        }
                        return null;
                      },
                    ),

              


                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Perbarui Makanan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildFormField({
    required String label,
    required String hint,
    required String initialValue,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}

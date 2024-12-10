import 'package:flutter/material.dart';

class ArticleEntryForm extends StatefulWidget {
  const ArticleEntryForm({Key? key}) : super(key: key);

  @override
  State<ArticleEntryForm> createState() => _ArticleEntryFormState();
}

class _ArticleEntryFormState extends State<ArticleEntryForm> {
  final _formKey = GlobalKey<FormState>();
  String _judul = "";
  String _subjudul = "";
  String _gambar = "";
  String _konten = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Tambah Artikel',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman sebelumnya dalam stack
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Judul",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _judul = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Judul tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Subjudul
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Subjudul",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _subjudul = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Subjudul tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // URL Gambar
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "URL Gambar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _gambar = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "URL Gambar tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Isi Artikel
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Isi Artikel",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      _konten = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Isi artikel tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Tombol Simpan
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Artikel berhasil ditambahkan!"),
                          ),
                        );
                        Navigator.pop(context); // Kembali ke stack sebelumnya
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
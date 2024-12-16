import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArticleEditForm extends StatefulWidget {
  final Article article; // Menambahkan parameter 'article'

  const ArticleEditForm({Key? key, required this.article}) : super(key: key); // Menambahkan 'article' dalam konstruktor

  @override
  State<ArticleEditForm> createState() => _ArticleEditFormState();
}

class _ArticleEditFormState extends State<ArticleEditForm> {
  final _formKey = GlobalKey<FormState>();
  late String _judul;
  late String _subjudul;
  late String _gambar;
  late String _konten;

  @override
  void initState() {
    super.initState();
    _judul = widget.article.judul;
    _subjudul = widget.article.subjudul;
    _gambar = widget.article.gambar;
    _konten = widget.article.konten;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text('Edit Artikel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
                  initialValue: _judul,
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
                  initialValue: _subjudul,
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
                  initialValue: _gambar,
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
                    // Validasi format URL
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasAbsolutePath) {
                      return "URL Gambar tidak valid!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Isi Artikel
                TextFormField(
                  initialValue: _konten,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Edit artikel yang ada
                        final response = await request.post(
                          "https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/edit-flutter/${widget.article.id}/",
                          {
                            "judul": _judul,
                            "subjudul": _subjudul,
                            "gambar": _gambar,
                            "konten": _konten,
                          },
                        );

                        if (response['message'] == 'Artikel berhasil diperbarui!') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Artikel berhasil diperbarui!"),
                            ),
                          );
                          Navigator.pop(context); // Kembali ke halaman sebelumnya
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal memperbarui artikel: ${response['message']}"),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Simpan Perubahan",
                      style: TextStyle(color: Colors.white), // Mengubah warna teks menjadi putih
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
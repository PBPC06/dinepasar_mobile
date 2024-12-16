import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/densiklopedia/models/article_entry.dart';
import 'package:dinepasar_mobile/densiklopedia/widgets/card_artikel.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/articleentry_form.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/articleedit_form.dart';
import 'package:dinepasar_mobile/densiklopedia/screens/view_article.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({super.key});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  late Future<List<Article>> futureArticles;

  Future<List<Article>> fetchArticles(CookieRequest request) async {
    final response = await request.get("http://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/densiklopedia/json/");
    
    // Convert JSON data into Article objects
    List<Article> listArticles = [];
    for (var d in response) {
      if (d != null) {
        listArticles.add(Article.fromJson(d));
      }
    }
    return listArticles;
  }

  Future<void> deleteArticle(String id, CookieRequest request) async {
    final url = "http://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/densiklopedia/delete-flutter/$id/";

    try {
      final response = await request.post(
        url,
        {}, // Tidak perlu mengirimkan data tambahan karena ID sudah di URL
      );

      if (response['success'] == true) {
        // Berhasil menghapus artikel
        if (!mounted) return; // Pastikan widget masih terpasang
        setState(() {
          futureArticles = fetchArticles(request);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Artikel berhasil dihapus!"),
          ),
        );
      } else {
        // Gagal menghapus artikel
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menghapus artikel: ${response['message']}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    futureArticles = fetchArticles(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Column(
        children: [
          // Tambah Artikel Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Navigate to Article Entry Form
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArticleEntryForm(),
                    ),
                  );
                  if (!mounted) return; // Tambahkan pengecekan ini
                  setState(() {
                    futureArticles = fetchArticles(request);
                  }); // Refresh the list after returning
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Tambah Artikel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFC67C4E),
                  side: const BorderSide(color: Color(0xFFC67C4E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          // FutureBuilder for Article List
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: futureArticles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) { // Menangani error
                  return Center(
                    child: Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada artikel yang tersedia.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (!mounted) return;
                      setState(() {
                        futureArticles = fetchArticles(request);
                      });
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        final article = snapshot.data![index];
                        return ArticleCard(
                          article: article,
                          onTap: () {
                            // Navigasi ke ViewArticle dengan melewatkan objek Article
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewArticle(article: article),
                              ),
                            );
                          },
                          onEdit: () {
                            // Navigasi ke form edit artikel
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleEditForm(
                                  article: article, // Pass the article to edit
                                ),
                              ),
                            ).then((_) {
                              if (!mounted) return; // Tambahkan pengecekan ini
                              setState(() {
                                futureArticles = fetchArticles(request);
                              });
                            });
                          },
                          onDelete: () {
                            // Konfirmasi sebelum menghapus artikel
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Artikel'),
                                content: const Text('Apakah Anda yakin ingin menghapus artikel ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteArticle(article.id, request); // UUID sebagai String
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
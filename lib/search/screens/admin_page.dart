import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:dinepasar_mobile/search/widgets/admin_food_card.dart';
import 'package:dinepasar_mobile/search/screens/productentry_form.dart';
import 'package:dinepasar_mobile/search/screens/edit_food.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Food> _foods = [];
  String _keyword = ''; // Untuk pencarian
  String _kategori = 'all'; // Default value for category
  String _harga = 'all'; // Default value for price range

  // Fungsi untuk mengambil data makanan
  Future<List<Food>> fetchFoods(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/search/api/foods/');
    // final response = await request.get('http://127.0.0.1:8000/search/api/foods/');
    var data = response;

    List<Food> listFoods = [];
    for (var d in data) {
      if (d != null) {
        listFoods.add(Food.fromJson(d));
      }
    }

    return listFoods;
  }

  // Fungsi untuk menampilkan dialog konfirmasi sebelum menghapus makanan
  Future<void> _confirmDeleteFood(int foodId, String foodName) async {
    bool? delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete '$foodName'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, Delete
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion, proceed with the delete action
    if (delete == true) {
      _deleteFood(foodId);
    }
  }


    Future<String> fetchUserId(BuildContext context) async {
  final request = context.read<CookieRequest>();
  // final response = await request.get('http://127.0.0.1:8000/editProfile/show-json-all/');
  final response = await request.get('http://127.0.0.1:8000/editProfile/show-json-all/');
  
  
  if (response is Map<String, dynamic>) {
    // Mengambil 'user_profile' yang berupa list
    var userProfileList = response['user_profile'] as List;
    
    // Ambil userId pertama dari list, atau sesuaikan jika perlu
    if (userProfileList.isNotEmpty) {
      final userProfile = userProfileList[0]; // Bisa disesuaikan untuk memilih user yang sesuai
      return userProfile['user_id'] ?? '';
    } else {
      throw Exception('No user profiles found');
    }
  } else {
    throw Exception('Failed to load profile data');
  }
}

   // Fungsi untuk menandai makanan sebagai sudah dicoba
  Future<void> markFoodAsTried(BuildContext context, String foodId) async {
    try {
      final userId = await fetchUserId(context);
      if (userId.isNotEmpty) {
        final request = context.read<CookieRequest>();
        // final url = 'http://127.0.0.1:8000/search/mark_food_flutter/$userId/$foodId/';
        final url = 'http://127.0.0.1:8000/search/mark_food_flutter/$userId/$foodId/';
        final response = await request.post(url, {});

        if (response is Map<String, dynamic> && response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Food marked as tried successfully!')),
          );
          // Optional: Refresh the food list if needed
          setState(() {});
        } else {
          // Jika response bukan success, bisa jadi ada pesan error dari server
          String errorMessage = 'Failed to mark food as tried.';
          if (response is Map<String, dynamic> && response['error'] != null) {
            errorMessage = response['error'];
          }
          throw Exception(errorMessage);
        }
      } else {
        throw Exception('User ID is empty.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  // Fungsi untuk menghapus makanan
  Future<void> _deleteFood(int foodId) async {
    final request = context.read<CookieRequest>();
    final url = 'http://127.0.0.1:8000/search/delete-flutter/$foodId/';
    // final url = 'http://127.0.0.1:8000/search/delete-flutter/$foodId/';

    try {
      final response = await request.post(url, {});

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Makanan berhasil dihapus!')),
        );
        setState(() {
          _foods.removeWhere((food) => food.pk == foodId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus makanan: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Admin - Manage Foods',
        style: TextStyle(
          color: Color.fromRGBO(202, 138, 4, 1), // Warna teks
          fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 242, 229, 1), // Warna latar belakang AppBar
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(202, 138, 4, 1), // Warna ikon
      ),
    ),
      body: Container(
        // color: Theme.of(context).colorScheme.secondary, // Background halaman
        child: Column(
          children: [
            // Pencarian dan filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (query) {
                      setState(() {
                        _keyword = query;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search for food...',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16), // Space between search and filters
                  // Filter Kategori dan Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center filters horizontally
                    children: [
                      // Filter Kategori
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton<String>(
                          value: _kategori,
                          onChanged: (value) {
                            setState(() {
                              _kategori = value ?? 'all';
                            });
                          },
                          items: ['all', 'Ayam Betutu', 'Sate', 'Es', 'Ayam', 'Pepes', 'Nasi', 'Sayur', 'Jajanan', 'Sambal', 'Tipat', 'Rujak', 'Bebek', 'Ikan', 'Kopi', 'Lawar', 'Babi Guling']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // Filter Harga
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton<String>(
                          value: _harga,
                          onChanged: (value) {
                            setState(() {
                              _harga = value ?? 'all';
                            });
                          },
                          items: ['all', 'Under 50k', '50k-100k', 'Above 100k']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tampilkan data makanan

          Expanded(
            child: FutureBuilder<List<Food>>(
              future: fetchFoods(request), // Fetch food data
              builder: (context, AsyncSnapshot<List<Food>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No foods available in Dinepasar'));
                }

                final foods = snapshot.data!;

                // Filter berdasarkan pencarian dan kategori
                final filteredFoods = foods.where((food) {
                  bool matchesSearch = food.fields.namaMakanan.toLowerCase().contains(_keyword.toLowerCase());
                  bool matchesCategory = _kategori == 'all' || food.fields.kategori == _kategori;
                  bool matchesPrice = true;

                  // Filter berdasarkan harga
                  if (_harga == 'Under 50k') {
                    matchesPrice = food.fields.harga < 50000;
                  } else if (_harga == '50k-100k') {
                    matchesPrice = food.fields.harga >= 50000 && food.fields.harga <= 100000;
                  } else if (_harga == 'Above 100k') {
                    matchesPrice = food.fields.harga > 100000;
                  }

                  return matchesSearch && matchesCategory && matchesPrice;
                }).toList();

                if (filteredFoods.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 40, color: Colors.grey),
                        Text("No results found.", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }


                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Display 2 columns
                      crossAxisSpacing: 10, // Spacing between columns
                      mainAxisSpacing: 10, // Spacing between rows
                      childAspectRatio: 0.7, // Aspect ratio of the card (height/width)
                    ),
                    itemCount: filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = filteredFoods[index];

                      return AdminFoodCard(
                        food: food,
                        onEdit: () async {
                          // print("Navigating to EditFoodPage with foodId: ${food.pk}");
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFoodPage(foodId: food.pk),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              int index = _foods.indexWhere((item) => item.pk == food.pk);
                              if (index != -1) {
                                _foods[index] = Food.fromJson(result);
                              }
                            });
                          }
                        },
                        onApprove: () {
                          markFoodAsTried(context, food.pk.toString());
                        },
                        onMore: () {
                          // print('More details for ${food.fields.namaMakanan}');
                        },
                        onDelete: () {
                          _confirmDeleteFood(food.pk, food.fields.namaMakanan);
                        },
                      );
                    },
                  ),
                );
              },
            ),
      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductEntryFormPage()),
          );

          if (result != null) {
            setState(() {
              fetchFoods(request); // Refresh data after adding a new food item
            });
          }
        },
        backgroundColor: const Color.fromRGBO(202, 138, 4, 1), // Warna latar belakang ikon Add
        child: const Icon(
          Icons.add,
          color: Colors.white, // Warna ikon (putih agar kontras)
        ),
      ),
    );
  }
}

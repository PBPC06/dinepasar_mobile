import 'dart:convert';
import 'package:dinepasar_mobile/profile/models/profile_entry.dart';
import 'package:dinepasar_mobile/profile/screens/edit_form.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


// Fungsi untuk mengambil data profil dengan autentikasi
Future<ListProfileEntry> fetchProfileData(BuildContext context) async {
  final request = context.read<CookieRequest>(); // Mengakses CookieRequest dari Provider
  final response = await request.get('https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/editProfile/show-json-all/');
  // final response = await request.get('http://127.0.0.1:8000/editProfile/show-json-all/');
  

  if (response is Map<String, dynamic>) {
    if (response['status'] == true) {
      return ListProfileEntry.fromJson(response);
    } else {
      throw Exception('Failed to load profile data: ${response['message']}');
    }
  } else {
    throw Exception('Unexpected response format');
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ListProfileEntry> futureListProfileEntry;

  @override
  void initState() {
    super.initState();
    futureListProfileEntry = fetchProfileData(context); // Ambil data profil
  }

  // Fungsi untuk mengambil semua data makanan
  Future<List<Food>> fetchAllFoods() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/search/api/foods/');
    // final response = await request.get('http://127.0.0.1:8000/search/api/foods/');
    
    
    if (response is List) {
      return response.map((foodJson) => Food.fromJson(foodJson)).toList();
    } else {
      throw Exception('Failed to load food data');
    }
  }

  // Fungsi untuk menghapus makanan dari riwayat
  Future<void> removeFoodFromHistory(String userId, int foodId) async {
    final url = Uri.parse('https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/editProfile/remove_food_flutter/$userId/$foodId/');
    // final url = Uri.parse('http://127.0.0.1:8000/editProfile/remove_food_flutter/$userId/$foodId/');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success']) {
        print('Food removed successfully');
        // Setelah penghapusan berhasil, perbarui UI dengan mem-fetch ulang data profil
        setState(() {
          futureListProfileEntry = fetchProfileData(context);
        });
      } else {
        print('Failed to remove food: ${data['error']}');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Fungsi untuk mengambil makanan yang dicoba berdasarkan id dari triedFoods
  Future<List<Food>> fetchTriedFoods(List<TriedFood> triedFoods) async {
    final allFoods = await fetchAllFoods(); // Ambil semua makanan terlebih dahulu
    List<Food> foods = [];
    
    for (var triedFood in triedFoods) {
      // Mencocokkan pk makanan dengan id triedFood
      final food = allFoods.firstWhere(
        (food) => food.pk == triedFood.id,
        orElse: () => Food(model: Model.SEARCH_FOOD, pk: -1, fields: Fields(
          namaMakanan: 'Not Found',
          restoran: '',
          kategori: '',
          gambar: '',
          deskripsi: '',
          harga: 0,
          rating: 0,
        )),
      );
      if (food.pk != -1) {
        foods.add(food);
      }
    }
    
    return foods;
  }

  // Fungsi untuk menampilkan dialog konfirmasi penghapusan
  void showDeleteConfirmationDialog(BuildContext context, String userId, int foodId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this food?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();  // Menutup dialog tanpa menghapus
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // Memanggil fungsi untuk menghapus makanan
                await removeFoodFromHistory(userId, foodId);
                Navigator.of(context).pop();  // Menutup dialog setelah penghapusan
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: FutureBuilder<ListProfileEntry>(
        future: futureListProfileEntry,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.userProfiles.isEmpty) {
            return const Center(child: Text('No profile data found'));
          }

          ListProfileEntry listProfileEntry = snapshot.data!;
          UserProfile profile = listProfileEntry.userProfiles.first;

          return FutureBuilder<List<Food>>(
            future: fetchTriedFoods(profile.triedFoods),
            builder: (context, foodSnapshot) {
              if (foodSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (foodSnapshot.hasError) {
                return Center(child: Text('Error: ${foodSnapshot.error}'));
              }

              return ListView(
                children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, ${profile.username}!',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Email: ${profile.email ?? '-'}'),
                          Text('Phone: ${profile.phone ?? '-'}'),
                          Text('About Me: ${profile.aboutMe ?? '-'}'),
                          ElevatedButton(
                            onPressed: () {
                             // Tampilkan dialog dengan EditProfilePage sebagai konten
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: EditProfilePage(userId: profile.userId), // Pass userId ke EditProfilePage
                                      );
                                    },
                                  ).then((_) {
                                    // Setelah dialog ditutup, refresh data profil
                                    setState(() {
                                      futureListProfileEntry = fetchProfileData(context);
                                    });
                                  });
                                },
                                child: const Text('Edit Profile'),
                              ),
                          ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Foods You\'ve Tried',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        foodSnapshot.hasData && foodSnapshot.data!.isNotEmpty
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: foodSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Food food = foodSnapshot.data![index];
                                  return Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                food.fields.gambar,
                                                width: double.infinity,
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                food.fields.namaMakanan,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                food.fields.deskripsi,
                                                style: const TextStyle(fontSize: 12),
                                                maxLines: 2, // Membatasi hingga 2 baris
                                                overflow: TextOverflow.ellipsis, // Menambahkan elipsis di akhir jika terpotong
                                              ),
                                            )

                                          ],
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.red,
                                            child: IconButton(
                                              onPressed: () {
                                                showDeleteConfirmationDialog(
                                                    context,
                                                    profile.userId,
                                                    food.pk);
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text('You haven\'t tried any foods yet.'),
                              ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

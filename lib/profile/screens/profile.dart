import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Fungsi untuk mendapatkan data user (melalui API)
  Future<Map<String, String>> fetchUserData() async {
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/editProfile/get_profile/'));
    // print(response.body);

      // print("apa");
      // print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      try {
        final data = json.decode(response.body); // Mengharapkan JSON
        print(data); // Cek data yang diterima
        return data;
      } catch (e) {
        throw Exception('Failed to parse JSON');
      }
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');  // Menampilkan error lebih detail di console
    throw Exception('Failed to load user data');
  }
}


  @override
  Widget build(BuildContext context) {
    // Menghitung lebar 2/3 halaman
    double containerWidth = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchUserData(),  // Memanggil fungsi untuk mendapatkan data user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menampilkan indikator loading jika data belum tersedia
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan error jika ada masalah dalam mengambil data
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // Menampilkan error jika data kosong
            return const Center(child: Text('No data available'));
          }

          // Mengambil data dari snapshot
          var userData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Hi, ${userData['username']}!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 64),

                  Container(
                    width: containerWidth,
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['username']!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Phone',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['phone']!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['email']!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'About me',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['aboutMe']!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 47, 47, 47),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Aksi untuk navigasi ke halaman Edit Profile
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 200, 161, 35),
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ),

                  const SizedBox(height: 64),

                  const Text(
                    'Food You\'ve Tried',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 47, 47, 47),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: containerWidth,
                    height: 300,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 64),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Aksi untuk logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 240, 80, 80),
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

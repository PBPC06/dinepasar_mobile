import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dinepasar_mobile/main/login.dart';  // Mengimpor halaman login untuk navigasi kembali

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String username = "John Doe";  // Ganti dengan data username yang sesuai
    double containerWidth = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Menampilkan teks "Hi, username!"
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Hi, ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '$username!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 200, 161, 35),
                      ),
                    ),
                  ],
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
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 47, 47, 47),
                        fontFamily: 'Roboto',
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
                    const Text(
                      '08123456789',
                      style: TextStyle(
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
                    const Text(
                      "johndoe@gmail.com",
                      style: TextStyle(
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
                    const Text(
                      "My name is John Doe. My life is sad. I'm a software engineer. Lmao. Bismillah UAS bisa semua. Bismillah semester 3 full A. Bismillah statprob ga jelek-jelek amat....",
                      style: TextStyle(
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
                    // Aksi untuk logout
                    logout(context);
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
      ),
    );
  }

  // Fungsi logout
  Future<void> logout(BuildContext context) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/manageData/logout/"), // URL endpoint logout
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Jika logout berhasil, arahkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // Jika terjadi error saat logout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout gagal!")),
      );
    }
  }
}

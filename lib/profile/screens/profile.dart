import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Variabel username (bisa diganti dengan data dinamis)
    String username = "John Doe"; // Ganti dengan data username yang sesuai

    // Menghitung lebar 2/3 halaman
    double containerWidth = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(  // Membuat halaman dapat di-scroll
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),  // Menyesuaikan padding kiri-kanan
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,  // Menjaga elemen tetap di tengah secara horizontal
            children: [
              const SizedBox(height: 32),
              // Menampilkan teks "Hi, username!"
              Text(
                'Hi, $username!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 64),  // Menjaga jarak antara nama dan deskripsi

              // Container untuk menampilkan username dan deskripsi
              Container(
                width: containerWidth,  // Menggunakan 2/3 dari lebar layar
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],  // Sesuaikan warna latar belakang seperti pada gambar
                  borderRadius: BorderRadius.circular(12.0),  // Menambahkan radius pada sudut-sudut
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,  // Warna bayangan
                      blurRadius: 6.0,  // Membuat bayangan lebih halus
                      offset: Offset(0, 3),  // Posisi bayangan
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,  // Menjaga teks di kiri
                  children: [
                    // Label "Username" dengan teks tebal
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,  // Membuat label bold
                        color: Color.fromARGB(255, 47, 47, 47),  // Warna teks label
                      ),
                    ),
                    const SizedBox(height: 4),  // Memberi jarak antara label dan username
                    // Nama pengguna
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Label untuk Phone
                    const Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,  // Membuat label bold
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Nomor telepon
                    const Text(
                      '08123456789',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Label untuk Email
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,  // Membuat label bold
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Alamat email
                    const Text(
                      "johndoe@gmail.com",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Label untuk About me
                    const Text(
                      'About me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,  // Membuat label bold
                        color: Color.fromARGB(255, 47, 47, 47),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Deskripsi singkat
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

              const SizedBox(height: 32),  // Menjaga jarak antara deskripsi dan menu aksi

              // Membuat tombol Edit Profile seperti yang ditunjukkan di gambar
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi untuk navigasi ke halaman Edit Profile
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 200, 161, 35),  // Warna tombol
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),  // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),  // Membuat tombol melengkung
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,  // Ukuran font pada tombol
                      fontWeight: FontWeight.bold,  // Font bold
                    ),
                    foregroundColor: Colors.white,  // Pastikan warna teks putih
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),

              const SizedBox(height: 64),

              // Sesi Food You've Tried (tulis di luar kontainer)
              const Text(
                'Food You\'ve Tried',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 47, 47, 47),
                ),
              ),

              const SizedBox(height: 32),

              // GridView untuk menampilkan produk dalam 2 kolom per baris
              SizedBox(
                width: containerWidth,  // Menyamai lebar container seperti Edit Profile
                height: 300, // Membatasi tinggi agar tidak terlalu tinggi
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,  // Menampilkan 2 produk per baris
                    crossAxisSpacing: 16.0,  // Jarak antar produk
                    mainAxisSpacing: 16.0,  // Jarak antar baris
                    childAspectRatio: 1,  // Menjaga rasio aspek gambar
                  ),
                  itemCount: 7,  // Ganti dengan jumlah produk yang dicoba
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://via.placeholder.com/150',  // Ganti dengan URL gambar produk
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 64),  // Jarak sebelum tombol logout

              // Tombol Logout
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi untuk logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 80, 80),  // Warna tombol
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),  // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),  // Membuat tombol melengkung
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,  // Ukuran font pada tombol
                      fontWeight: FontWeight.bold,  // Font bold
                    ),
                    foregroundColor: Colors.white,  // Pastikan warna teks putih
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
}

# Proyek Akhir Semester C06 - PBP Gasal 2024/2025
- [Nama Aplikasi](#nama-aplikasi-dinepasar)
- [Anggota Kelompok C06](#anggota-kelompok-c06)
- [Deskripsi Aplikasi](#deskripsi-aplikasi)
- [Modul Aplikasi](#modul-aplikasi)
- [Sumber Initial Dataset](#sumber-initial-dataset)
- [Role Pengguna](#role-pengguna)
- [Alur Pengintegrasian dengan Web Service](#alur-pengintegrasian-dengan-web-service)

# Nama Aplikasi: Dinepasar


### Anggota Kelompok C06
| Nama | NPM |
| :--------------: | :--------: |
| Wirya Dharma Kurnia | 2306152115 |
| Calvin Joy Tarigan | 2306244974 |
| Namira Aulia | 2306165931 |
| Joanne Kenisa Adelina | 2306275626 |
| Anindya Nabila Syifa | 2306165805 |


## Deskripsi Aplikasi
Denpasar, Bali terkenal sebagai statusnya sebagai destinasi pariwisata yang terkenal dengan keindahan budaya dan ragam kulinernya. Sebagai salah satu destinasi favorit turis, Denpasar tidak hanya menyajikan pantai yang eksotis dan keunikan budaya, namun juga variasi hidangan lezat yang mampu memanjakan lidah.

Di tengah keberagaman kuliner tersebut, turis seringkali menemui kesulitan dalam menentukan tempat makan yang sesuai dengan selera pribadi. Untuk mengatasi masalah tersebut, Dinepasar hadir sebagai platform digital yang dirancang khusus untuk menemukan restoran yang sesuai dengan permintaan pengguna. Aplikasi ini menyediakan informasi yang lengkap dan terpercaya mengenai restoran-restoran yang ada di kota Denpasar, termasuk menu, harga, lokasi, rating, hingga dari review pengunjung lain. 

Lebih dari itu, Dinepasar dapat menjadi teman setia dalam mengeksplorasi cita rasa khas kuliner Denpasar. Hadirnya aplikasi ini diharapkan dapat memberikan pengalaman liburan yang lebih mudah, praktis, dan berkesan dalam memenuhi kebutuhan kuliner para turis.


## Modul Aplikasi
- Autentikasi, Role Pengguna, dan Halaman Utama

Dinepasar menyediakan fitur autentikasi dengan halaman registrasi dan login. Setelah login, pengguna akan diarahkan ke landing page yang menampilkan pesan pembuka. Sejak memasuki halaman utama dan seterusnya, fitur yang dapat digunakan pengguna akan ditentukan oleh rolenya, sebagai user biasa atau sebagai admin.

- Edit Profile dan Riwayat Makanan yang Pernah Dicoba

Pengguna dapat mengedit profile yang telah dibuat sebelumnya pada halaman tertentu. Halaman tersebut juga memuat riwayat makanan yang pernah dicoba oleh pengguna tersebut.
- Katalog produk (makanan dan minuman) serta terdapat fitur untuk mencari dan juga filter makanan berdasar kategori dan range harga

Pengguna dapat melihat berbagai macam card makanan dan minuman serta mencari makanan melalui search bar di bagian atas halaman. Pengguna juga dapat melakukan filter makanan berdasar kategori dan juga range harga makanan. Terdapat button details dan review di setiap card makanan yang apabila ditekan akan mengarahkan ke page food details ataupun food review.
- Preview Restoran dan Tambahkan ke Favorit

Pada halaman preview makanan, pengguna dapat melihat informasi lengkap mengenai suatu makanan. Di halaman ini, pengguna juga memiliki opsi untuk menambahkan makanan tersebut ke dalam daftar favorit atau wishlist melalui tombol yang telah disediakan. Halaman favorit memungkinkan pengguna untuk melihat daftar makanan favorit mereka, dan di bagian bawah halaman, terdapat rekomendasi restoran lain yang sesuai dengan kategori makanan yang disukai pengguna.
- Ulasan

Pengguna dapat menambahkan ulasan melalui tombol yang tersedia di halaman preview dan melihat ulasan tersebut di halaman khusus ulasan. Hal ini memungkinkan pengguna untuk berbagi pengalaman dan membantu pengguna lain dalam menemukan hidangan yang sesuai dengan selera mereka.

- Informasi tentang Denpasar

Dinepasar menyediakan halaman khusus bernama Densiklopedia yang berisi informasi tentang berbagai hal terkait makanan dan juga minuman terkait di Denpasar. Halaman ini juga dilengkapi dengan penambahan artikel sebagai cara untuk setiap pengguna berbagi informasi spesifik mengenai Denpasar.

Berikut link menuju detail penjelasan modul dan pembagiannya:
https://docs.google.com/spreadsheets/d/1D2Tk0wCMrCWT3HMLjPZVTOpfQ64sDqC_8w8SRwu9P0g/edit?usp=sharing


## Sumber Initial Dataset
- Dataset:

https://docs.google.com/spreadsheets/d/148R7MeizpXdl2PQJxHuYX6YQg4IeXM9quS3PN8Lgwts/edit?gid=0#gid=0 

- Sumber dataset:

https://www.google.com/maps

https://gofood.co.id/


## Role Pengguna
- User

User setelah login bisa mengakses berbagai fitur seperti autentikasi, halaman profil pengguna untuk melihat dan mengedit profil, serta halaman utama yang mengintegrasikan seluruh data. User dapat mencari restoran menggunakan search bar, melihat daftar restoran dari A-Z, melihat detail restoran beserta ulasan, dan menyimpan restoran ke dalam favorit. Ada juga halaman khusus untuk informasi tentang Denpasar. 

- Admin

Selain memiliki akses seperti user, juga dapat menambahkan dan menghapus card restoran pada halaman pencarian.

## Alur Pengintegrasian dengan Web Service
Integrasi antara web service dan aplikasi web dilakukan dengan langkah-langkah berikut:
1. Menggunakan library `http` untuk menghubungkan aplikasi mobile dengan web melalui pengiriman permintaan (request).
2. Memanfaatkan library `pbp_django_auth` guna mengelola cookie serta memastikan setiap request yang dikirim ke server telah terautentikasi dan terotorisasi.
3. Membuat model berdasarkan respons JSON dari web service, dengan bantuan QuickType untuk mempermudah pembuatan model aplikasi melalui konversi data JSON menjadi kode Dart.
4. Dalam aplikasi Flutter, menggunakan `FutureBuilder` untuk menampilkan data setelah memastikan data telah dikonversi ke model yang sesuai.


## Tautan Deployment Aplikasi
(Tautan deployment aplikasi)


## Tautan Design Aplikasi
https://www.figma.com/design/TSFcu7BFIfJ4H2hhmGNuBi/Dinepasar-Flutter-Design?node-id=0-1&t=JvM71gqiFklpPgz7-1
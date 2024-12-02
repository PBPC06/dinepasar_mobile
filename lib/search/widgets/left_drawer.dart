// import 'package:flutter/material.dart';
// import 'package:dinepasar_mobile/search/screens/menu.dart';
// // TODO: Impor halaman MoodEntryFormPage jika sudah dibuat
// import 'package:dinepasar_mobile/search/screens/productentry_form.dart';



// class LeftDrawer extends StatelessWidget {
//   const LeftDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           DrawerHeader(
//               decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//             child: const Column(
//               children: [
//                 Text(
//                   'DINEPASAR',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Padding(padding: EdgeInsets.all(8)),
//                 Text(
//                   "Ayo jelajahi produk dengan kearifan lokal di sini!",
//                   textAlign: TextAlign.center, // Center alignment
//                   style: TextStyle(
//                   fontSize: 15,           // Ukuran font 15
//                   color: Colors.black,     // Warna teks putih
//                   fontWeight: FontWeight.normal,  // Weight biasa (normal)
//                   ),
//                 ),
//               ],
//             ),
//           ),
//               ListTile(
//             leading: const Icon(Icons.home_outlined),
//             title: const Text('Halaman Utama'),
//             // Bagian redirection ke MyHomePage
//             onTap: () {
//               Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MyHomePage(),
//                   ));
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.shopping_bag_outlined),
//             title: const Text('Tambah Produk'),
//             // Bagian redirection ke ProductEntryFormPage
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductEntryFormPage(),
//               ));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
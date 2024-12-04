import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/main/login.dart';
import 'package:dinepasar_mobile/main/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'DINEPASAR',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
          ).copyWith(secondary: const Color.fromRGBO(255, 238, 169, 100)),
        ),
        home: const AppEntryPoint(),
      ),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    // Periksa apakah pengguna sudah login
    if (request.loggedIn) {
      // Jika sudah login, arahkan ke halaman utama
      return const MyHomePage();
    } else {
      // Jika belum login, arahkan ke halaman login
      return const LoginPage();
    }
  }
}

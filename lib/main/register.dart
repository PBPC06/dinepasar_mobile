import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dinepasar_mobile/main/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  String? _userType = "User"; // Default is User

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  DropdownButtonFormField<String>(
                    value: _userType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _userType = newValue;
                      });
                    },
                    items: <String>['User', 'Admin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Register as',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  if (_userType == 'Admin')
                    TextFormField(
                      controller: _referralCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Referral Code',
                        hintText: 'Enter referral code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                      validator: (value) {
                        if (_userType == 'Admin' && (value == null || value.isEmpty)) {
                          return 'Referral code is required for Admin registration';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields.')),
                        );
                        return; // Jangan kirim request jika ada field yang kosong
                      }
                      final Map<String, dynamic> requestData = {
                        "username": _usernameController.text,
                        "password1": _passwordController.text,
                        "password2": _confirmPasswordController.text,
                        "isAdmin": _userType == "Admin" ? "Admin" : "User", 
                        "referral_code": _referralCodeController.text,
                      };

                      print("Request Data: $requestData");  // Debugging: lihat data yang dikirim

                      final response = await http.post(
                        Uri.parse("http://127.0.0.1:8000/manageData/register/"),
                        headers: {
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode(requestData),
                      );
                      print("Response status: ${response.statusCode}");
                      print("Response body: ${response.body}");







                      if (response.statusCode == 201) {
                        // Registrasi berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Successfully registered!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      } else {
                        print("Response Body: ${response.body}");  // Cek respons dari server
                        // Hanya tampilkan pesan error dari server
                        Map<String, dynamic> responseData = jsonDecode(response.body);
                        String errorMessage = responseData['message'] ?? 'Registrasi gagal';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

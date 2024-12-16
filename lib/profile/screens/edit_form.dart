import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _phone;
  String? _aboutMe;

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aboutMeController = TextEditingController();

  bool _isLoading = false; // Indikator loading

  @override
  void initState() {
    super.initState();
    // Ambil data profil dari server dan set controller text
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    setState(() {
      _isLoading = true; // Set loading true saat mengambil data
    });

    // Ambil data profil dari server menggunakan widget.userId
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/editProfile/getProfile/${widget.userId}/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _aboutMeController.text = data['about_me'] ?? '';
      });
    } else {
      // Handle error jika gagal mengambil data
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to load profile data'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false; // Set loading false setelah data diambil
    });
  }

  Future<void> updateProfile() async {
    setState(() {
      _isLoading = true; // Set loading true saat proses update
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/editProfile/edit-flutter/${widget.userId}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _email,
        'phone': _phone,
        'about_me': _aboutMe,
      }),
    );

    if (response.statusCode == 200) {
      // Ambil kembali data terbaru setelah update berhasil
      await fetchProfileData();
      Navigator.of(context).pop();  // Close the form after success
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update profile'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false; // Set loading false setelah update selesai
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: _isLoading  // Menampilkan indikator loading saat sedang memuat
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (value) => _email = value,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      counterText: "", 
                    ),
                    keyboardType: TextInputType.phone, 
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 15, 
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) => _phone = value,
                  ),
                  TextFormField(
                    controller: _aboutMeController,
                    decoration: const InputDecoration(labelText: 'About Me'),
                    onSaved: (value) => _aboutMe = value,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cancel action
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            updateProfile();  // Update profile when form is valid
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

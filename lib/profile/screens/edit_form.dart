import 'dart:convert';
import 'package:dinepasar_mobile/profile/models/profile_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
    fetchAndSetProfileData();
  }

  Future<void> fetchAndSetProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserProfile? profile = await fetchProfileData();
      if (profile != null) {
        setState(() {
          _emailController.text = profile.email;
          _phoneController.text = profile.phone;
          _aboutMeController.text = profile.aboutMe;
        });
      } else {
        showErrorDialog('Profil pengguna tidak ditemukan.');
      }
    } catch (e) {
      // Handle error jika terjadi exception
      showErrorDialog('Terjadi kesalahan saat memuat data profil.');
      debugPrint('Error fetching profile data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<UserProfile?> fetchProfileData() async {
    final request = context.read<CookieRequest>();
    // final response = await request.get('http://127.0.0.1:8000/editProfile/show-json-all/');
    final response = await request.get('https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/editProfile/show-json-all/');

    if (response is Map<String, dynamic>) {
      UserProfileResponse profileListResponse = UserProfileResponse.fromJson(response);
      if (profileListResponse.status && profileListResponse.userProfile.isNotEmpty) {
        return profileListResponse.userProfile.first;
      } else {
        throw Exception('Profil pengguna tidak ditemukan.');
      }
    } else {
      throw Exception('Format respons tidak terduga.');
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        // 'http://127.0.0.1:8000/editProfile/edit-flutter/${widget.userId}/',
        'https://namira-aulia31-dinepasar.pbp.cs.ui.ac.id/editProfile/edit-flutter/${widget.userId}/',
        json.encode({
          'email': _email,
          'phone': _phone,
          'about_me': _aboutMe,
        }),
      );

      if (response is Map<String, dynamic> && response['status'] == true) {
        await fetchProfileData();
        Navigator.of(context).pop(true); // Kembali dengan hasil sukses
      } else {
        showErrorDialog('Gagal memperbarui profil.');
      }
    } catch (e) {
      showErrorDialog('Terjadi kesalahan saat memperbarui profil.');
      debugPrint('Error updating profile: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  // Fungsi validasi email dengan regex yang lebih kuat
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Regex untuk validasi email yang lebih komprehensif
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9]+([._\-+]?[a-zA-Z0-9]+)*@[a-zA-Z0-9]+([.\-]?[a-zA-Z0-9]+)*(\.[a-zA-Z]{2,})+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  // Fungsi validasi nomor telepon
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!value.startsWith('08')) {
      return 'Nomor telepon harus diawali 08';
    }
    // Regex untuk memastikan hanya digit dan panjang 10-15 digit
    final phoneRegex = RegExp(r'^08\d{8,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  // Fungsi validasi About Me
  String? _validateAboutMe(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'About Me tidak boleh kosong';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Field Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      onSaved: (value) => _email = value,
                    ),
                    const SizedBox(height: 16.0),
                    // Field Nomor Telepon
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        counterText: "",
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 15,
                      validator: _validatePhone,
                      onSaved: (value) => _phone = value,
                    ),
                    const SizedBox(height: 16.0),
                    // Field About Me
                    TextFormField(
                      controller: _aboutMeController,
                      decoration: const InputDecoration(labelText: 'About Me'),
                      maxLines: 3,
                      validator: _validateAboutMe,
                      onSaved: (value) => _aboutMe = value,
                    ),
                    const SizedBox(height: 20),
                    // Tombol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Aksi batal
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    updateProfile(); // Update profile saat form valid
                                  }
                                },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// tess
import 'package:dinepasar_mobile/profile/models/profile_entry.dart';
import 'package:dinepasar_mobile/profile/screens/edit_form.dart';
import 'package:dinepasar_mobile/search/models/food_entry.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:dinepasar_mobile/main/screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfileResponse> futureUserProfileResponse;

  @override
  void initState() {
    super.initState();
    futureUserProfileResponse = fetchProfileData();
  }

  Future<List<Food>> fetchAllFoods() async {
    try {
      final request = context.read<CookieRequest>();
      // final response = await request.get('http://127.0.0.1:8000/search/api/foods/');
      final response =
          await request.get('http://127.0.0.1:8000/search/api/foods/');

      if (response is List) {
        return response.map((foodJson) => Food.fromJson(foodJson)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching foods: $e');
    }
    return [];
  }

  Future<void> removeFoodFromHistory(String userId, int foodId) async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.post(
          // 'http://127.0.0.1:8000/editProfile/remove_food_flutter/$userId/$foodId/',
          'http://127.0.0.1:8000/editProfile/remove_food_flutter/$userId/$foodId/',
          {});

      if (response['success'] == true) {
        setState(() {
          futureUserProfileResponse = fetchProfileData();
        });
      }
    } catch (e) {
      debugPrint('Error removing food: $e');
    }
  }

  Future<UserProfileResponse> fetchProfileData() async {
    final request = context.read<CookieRequest>();
    // final response = await request.get('http://127.0.0.1:8000/editProfile/show-json-all/');
    final response =
        await request.get('http://127.0.0.1:8000/editProfile/show-json-all/');

    if (response is Map<String, dynamic>) {
      return UserProfileResponse.fromJson(response);
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<List<Food>> fetchTriedFoods(List<TriedFood>? triedFoods) async {
    if (triedFoods == null || triedFoods.isEmpty) return [];

    final allFoods = await fetchAllFoods();
    return allFoods
        .where((food) => triedFoods.any((triedFood) => triedFood.id == food.pk))
        .toList();
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String userId, int foodId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this food?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await removeFoodFromHistory(userId, foodId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi helper untuk menampilkan field atau 'Not available'
  String displayField(String field) {
    return field.trim().isEmpty ? 'Not available' : field;
  }

  Widget buildProfileInfo(UserProfile? profile) {
    // Handle null profile
    if (profile == null) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Profile data not available'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${displayField(profile.username)}!',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: ${displayField(profile.email)}'),
            Text('Phone: ${displayField(profile.phone)}'),
            Text('About Me: ${displayField(profile.aboutMe)}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: EditProfilePage(userId: profile.userId),
                    );
                  },
                ).then((_) {
                  setState(() {
                    futureUserProfileResponse = fetchProfileData();
                  });
                });
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final request = context.read<CookieRequest>();
    await request.logout('http://127.0.0.1:8000/manageData/logout_flutter/');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget buildFoodGrid(List<Food> foods, UserProfile profile) {
    if (foods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('You haven\'t tried any foods yet.'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      food.fields.namaMakanan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      food.fields.deskripsi,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    onPressed: () => showDeleteConfirmationDialog(
                        context, profile.userId, food.pk),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
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
      body: FutureBuilder<UserProfileResponse>(
        future: futureUserProfileResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading profile: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final userProfileResponse = snapshot.data;
          if (userProfileResponse == null) {
            return const Center(child: Text('Unable to load profile data'));
          }

          final profile = userProfileResponse.userProfile.isNotEmpty
              ? userProfileResponse.userProfile.first
              : null;

          return FutureBuilder<List<Food>>(
            future: fetchTriedFoods(profile?.triedFoods),
            builder: (context, foodSnapshot) {
              if (foodSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (foodSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading foods: ${foodSnapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final foods = foodSnapshot.data ?? [];

              return ListView(
                children: [
                  buildProfileInfo(profile),
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
                        const SizedBox(height: 16),
                        if (profile != null) buildFoodGrid(foods, profile),
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
// Model untuk mengambil data profil pengguna
class ListProfileEntry {
  List<UserProfile> userProfiles;

  ListProfileEntry({required this.userProfiles});

  factory ListProfileEntry.fromJson(Map<String, dynamic> json) {
    return ListProfileEntry(
      userProfiles: List<UserProfile>.from(
        json["user_profile"].map((x) => UserProfile.fromJson(x)),
      ),
    );
  }
}

class UserProfile {
  String userId;
  String username;
  String? email;
  String? phone;
  String? aboutMe;
  List<TriedFood> triedFoods;

  UserProfile({
    required this.userId,
    required this.username,
    this.email,
    this.phone,
    this.aboutMe,
    required this.triedFoods,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json["user_id"].toString(),
      username: json["username"] ?? '',
      email: json["email"],
      phone: json["phone"],
      aboutMe: json["about_me"],
      triedFoods: List<TriedFood>.from(
        json["tried_foods"].map((x) => TriedFood.fromJson(x)),
      ),
    );
  }
}

class TriedFood {
  int id;
  String namaMakanan;

  TriedFood({
    required this.id,
    required this.namaMakanan,
  });

  factory TriedFood.fromJson(Map<String, dynamic> json) {
    return TriedFood(
      id: json["id"],
      namaMakanan: json["nama_makanan"],
    );
  }
}

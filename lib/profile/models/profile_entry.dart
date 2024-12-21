class UserProfileResponse {
  final bool status;
  final List<UserProfile> userProfile;

  UserProfileResponse({
    required this.status,
    required this.userProfile,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    var userProfilesFromJson = json['user_profile'] as List<dynamic>?;

    List<UserProfile> userProfileList = userProfilesFromJson != null
        ? userProfilesFromJson.map((item) => UserProfile.fromJson(item)).toList()
        : [];

    return UserProfileResponse(
      status: json['status'],
      userProfile: userProfileList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user_profile': userProfile.map((user) => user.toJson()).toList(),
    };
  }
}


class UserProfile {
  final String userId;
  final String username;
  final String email;
  final String phone;
  final String aboutMe;
  final List<TriedFood> triedFoods;

  UserProfile({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.aboutMe,
    required this.triedFoods,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var triedFoodsFromJson = json['tried_foods'] as List<dynamic>?;

    List<TriedFood> triedFoodsList = triedFoodsFromJson != null
        ? triedFoodsFromJson.map((item) => TriedFood.fromJson(item)).toList()
        : [];

    return UserProfile(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      aboutMe: json['about_me'] ?? '',
      triedFoods: triedFoodsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'phone': phone,
      'about_me': aboutMe,
      'tried_foods': triedFoods.map((food) => food.toJson()).toList(),
    };
  }
}

class TriedFood {
  final int id;
  final String namaMakanan;

  TriedFood({
    required this.id,
    required this.namaMakanan,
  });

  factory TriedFood.fromJson(Map<String, dynamic> json) {
    return TriedFood(
      id: json['id'],
      namaMakanan: json['nama_makanan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_makanan': namaMakanan,
    };
  }
}

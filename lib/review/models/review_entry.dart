// To parse this JSON data, do
//
//     final foodReview = foodReviewFromJson(jsonString);

import 'dart:convert';

List<FoodReview> foodReviewFromJson(String str) =>
    List<FoodReview>.from(json.decode(str).map((x) => FoodReview.fromJson(x)));

String foodReviewToJson(List<FoodReview> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodReview {
  String model;
  int pk;
  bool is_admin;
  Fields fields;

  FoodReview({
    required this.model,
    required this.pk,
    required this.is_admin,
    required this.fields,
  });

  factory FoodReview.fromJson(Map<String, dynamic> json) => FoodReview(
        model: json["model"],
        pk: json["pk"],
        is_admin: json["is_admin"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "is_admin": is_admin,
        "fields": fields.toJson(),
      };
}

class Fields {
  String user;
  int food;
  String gambar;
  String namaMakanan;
  double rating;
  String reviewMessage;
  DateTime createdAt;

  Fields({
    required this.user,
    required this.food,
    required this.gambar,
    required this.namaMakanan,
    required this.rating,
    required this.reviewMessage,
    required this.createdAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        food: json["food"],
        gambar: json["gambar"],
        namaMakanan: json["nama_makanan"],
        rating: json["rating"],
        reviewMessage: json["review_message"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "food": food,
        "gambar": gambar,
        "nama_makanan": namaMakanan,
        "rating": rating,
        "review_message": reviewMessage,
        "created_at": createdAt.toIso8601String(),
      };
}

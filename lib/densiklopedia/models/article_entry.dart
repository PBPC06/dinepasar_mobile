// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

List<Article> articleFromJson(String str) => List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
    String id;
    String judul;
    String gambar;
    String subjudul;
    String konten;

    Article({
        required this.id,
        required this.judul,
        required this.gambar,
        required this.subjudul,
        required this.konten,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        judul: json["judul"],
        gambar: json["gambar"],
        subjudul: json["subjudul"],
        konten: json["konten"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "gambar": gambar,
        "subjudul": subjudul,
        "konten": konten,
    };
}
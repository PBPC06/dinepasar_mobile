// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
    Model model;
    int pk;
    Fields fields;

    Food({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String namaMakanan;
    String restoran;
    String kategori;
    String gambar;
    String deskripsi;
    int harga;
    int rating;

    Fields({
        required this.namaMakanan,
        required this.restoran,
        required this.kategori,
        required this.gambar,
        required this.deskripsi,
        required this.harga,
        required this.rating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaMakanan: json["nama_makanan"],
        restoran: json["restoran"],
        kategori: json["kategori"],
        gambar: json["gambar"],
        deskripsi: json["deskripsi"],
        harga: json["harga"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "nama_makanan": namaMakanan,
        "restoran": restoran,
        "kategori": kategori,
        "gambar": gambar,
        "deskripsi": deskripsi,
        "harga": harga,
        "rating": rating,
    };
}

enum Model {
    SEARCH_FOOD
}

final modelValues = EnumValues({
    "search.food": Model.SEARCH_FOOD
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}

class Food {
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double price;
  bool isEaten;

  Food({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.isEaten = false,
  });
}

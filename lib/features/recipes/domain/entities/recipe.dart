class Recipe {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double calories;
  final double proteins;
  final double fats;
  final double carbs;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });
}

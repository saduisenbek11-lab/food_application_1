import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.calories,
    required super.proteins,
    required super.fats,
    required super.carbs,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Без названия',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      proteins: (json['proteins'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'carbs': carbs,
    };
  }
}

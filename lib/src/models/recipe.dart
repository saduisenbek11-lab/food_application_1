import 'package:equatable/equatable.dart';
import 'ingredient.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String category;
  final String image;
  final String time;
  final int servings;
  final int calories;
  final String difficulty;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final double rating;

  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.time,
    required this.servings,
    required this.calories,
    required this.difficulty,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.rating,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      time: json['time'] ?? '',
      servings: json['servings'] ?? 0,
      calories: json['calories'] ?? 0,
      difficulty: json['difficulty'] ?? 'Средне',
      description: json['description'] ?? '',
      ingredients: (json['ingredients'] as List?)
              ?.map((i) => Ingredient.fromJson(i))
              .toList() ??
          [],
      steps: List<String>.from(json['steps'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'image': image,
      'time': time,
      'servings': servings,
      'calories': calories,
      'difficulty': difficulty,
      'description': description,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps,
      'rating': rating,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        image,
        time,
        servings,
        calories,
        difficulty,
        description,
        ingredients,
        steps,
        rating,
      ];
}

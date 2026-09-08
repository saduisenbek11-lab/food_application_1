import 'package:dio/dio.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';

class RecipeApi {
  final Dio dio;

  RecipeApi({required this.dio});

  Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    final response = await dio.get('/filter.php', queryParameters: {'c': category});
    final meals = response.data['meals'] as List?;
    if (meals == null) return [];
    
    return meals.map((m) => Recipe(
      id: m['idMeal'],
      title: m['strMeal'],
      category: category,
      image: m['strMealThumb'],
      time: '',
      servings: 0,
      calories: 0,
      difficulty: 'Средне',
      description: '',
      ingredients: const [],
      steps: const [],
      rating: 0,
    )).toList();
  }

  Future<Recipe?> fetchRecipeById(String id) async {
    final response = await dio.get('/lookup.php', queryParameters: {'i': id});
    final meals = response.data['meals'] as List?;
    if (meals == null || meals.isEmpty) return null;
    
    return _parseFullRecipe(meals[0]);
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await dio.get('/search.php', queryParameters: {'s': query});
    final meals = response.data['meals'] as List?;
    if (meals == null) return [];
    
    return meals.map((m) => Recipe(
      id: m['idMeal'],
      title: m['strMeal'],
      category: '',
      image: m['strMealThumb'],
      time: '',
      servings: 0,
      calories: 0,
      difficulty: 'Средне',
      description: '',
      ingredients: const [],
      steps: const [],
      rating: 0,
    )).toList();
  }

  Future<List<Recipe>> fetchRandomRecipes(int count) async {
    final List<Future<Response>> requests = List.generate(
      count, 
      (_) => dio.get('/random.php')
    );
    
    final responses = await Future.wait(requests);
    final recipes = <Recipe>[];
    
    for (var response in responses) {
      final meals = response.data['meals'] as List?;
      if (meals != null && meals.isNotEmpty) {
        recipes.add(_parseFullRecipe(meals[0]));
      }
    }
    
    return recipes;
  }

  Recipe _parseFullRecipe(Map<String, dynamic> meal) {
    final ingredients = <Ingredient>[];
    for (var i = 1; i <= 20; i++) {
      final name = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];
      if (name != null && name.toString().trim().isNotEmpty) {
        ingredients.add(Ingredient(
          name: name.toString().trim(),
          amount: (measure ?? '').toString().trim(),
        ));
      }
    }

    final instructions = meal['strInstructions'] as String? ?? '';
    final steps = instructions
        .split(RegExp(r'\r?\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Recipe(
      id: meal['idMeal'],
      title: meal['strMeal'],
      category: meal['strCategory'] ?? '',
      image: meal['strMealThumb'],
      time: '',
      servings: 0,
      calories: 0,
      difficulty: 'Средне',
      description: meal['strArea'] != null ? 'Кухня: ${meal['strArea']}' : '',
      ingredients: ingredients,
      steps: steps,
      rating: 0,
    );
  }
}

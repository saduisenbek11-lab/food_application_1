import '../api/recipe_api.dart';
import '../models/recipe.dart';
import '../models/category.dart';

class RecipeService {
  final RecipeApi api;

  RecipeService({required this.api});

  static const Map<String, Map<String, String>> _categoryMap = {
    'Breakfast': {'label': 'Завтрак', 'emoji': '🍳'},
    'Chicken': {'label': 'Курица', 'emoji': '🍗'},
    'Beef': {'label': 'Говядина', 'emoji': '🥩'},
    'Pasta': {'label': 'Паста', 'emoji': '🍝'},
    'Seafood': {'label': 'Морепродукты', 'emoji': '🦐'},
    'Dessert': {'label': 'Десерт', 'emoji': '🍰'},
    'Vegetarian': {'label': 'Вегетарианское', 'emoji': '🥗'},
    'Vegan': {'label': 'Веганское', 'emoji': '🌱'},
  };

  Future<List<RecipeCategory>> getCategories() async {
    return _categoryMap.entries.map((e) => RecipeCategory(
      id: e.key,
      label: e.value['label']!,
      emoji: e.value['emoji']!,
    )).toList();
  }

  Future<List<Recipe>> getRecipesByCategory(String category) {
    return api.fetchRecipesByCategory(category);
  }

  Future<Recipe?> getRecipeById(String id) {
    return api.fetchRecipeById(id);
  }

  Future<List<Recipe>> searchRecipes(String query) {
    return api.searchRecipes(query);
  }

  Future<List<Recipe>> getRandomRecipes(int count) {
    return api.fetchRandomRecipes(count);
  }
}

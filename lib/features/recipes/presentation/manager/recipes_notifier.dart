import 'package:flutter/material.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/usecases/get_recipes_usecase.dart';

class RecipesNotifier extends ChangeNotifier {
  final GetRecipesUseCase getRecipesUseCase;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  RecipesNotifier(this.getRecipesUseCase);

  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await getRecipesUseCase.execute();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

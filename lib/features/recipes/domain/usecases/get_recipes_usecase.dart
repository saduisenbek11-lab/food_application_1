import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase(this.repository);

  Future<List<Recipe>> execute() {
    return repository.getRecipes();
  }
}

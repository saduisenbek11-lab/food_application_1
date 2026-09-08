import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Recipe>> getRecipes() async {
    // Репозиторий просто пробрасывает вызов к источнику данных
    // Здесь также можно добавить логику кэширования (LocalDataSource)
    return await remoteDataSource.getRecipes();
  }
}

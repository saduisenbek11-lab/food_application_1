import 'package:dio/dio.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes({String query = ''});
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;

  RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RecipeModel>> getRecipes({String query = ''}) async {
    try {
      final response = await dio.get(
        '/recipes',
        queryParameters: query.isNotEmpty ? {'search': query} : null,
      );

      if (response.statusCode == 200) {
        // Обработка структуры { "data": [...] } или просто массива [...]
        final List<dynamic> data = response.data is Map 
            ? (response.data['data'] ?? []) 
            : response.data;
            
        return data.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить рецепты: $e');
    }
  }
}

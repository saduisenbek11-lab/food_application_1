import '../models/recipe_model.dart';
import 'recipe_remote_data_source.dart';

class RecipeMockDataSourceImpl implements RecipeRemoteDataSource {
  @override
  Future<List<RecipeModel>> getRecipes({String query = ''}) async {
    // Имитация задержки сети
    await Future.delayed(const Duration(seconds: 1));
    
    final allRecipes = [
      RecipeModel(
        id: 1,
        title: 'Борщ классический',
        description: 'Традиционный украинский суп с овощами и мясом.',
        imageUrl: 'https://img.delo-vcusa.ru/2016/12/Borshh-klassicheskij.jpg',
        calories: 150.0,
        proteins: 5.0,
        fats: 8.0,
        carbs: 12.0,
      ),
      RecipeModel(
        id: 2,
        title: 'Паста Карбонара',
        description: 'Итальянская паста с беконом, яйцом и сыром пармезан.',
        imageUrl: 'https://povar.ru/uploads/6b/5b/c2/f7/pasta_karbonara_klassicheskaya-473539.jpg',
        calories: 450.0,
        proteins: 15.0,
        fats: 25.0,
        carbs: 40.0,
      ),
      RecipeModel(
        id: 3,
        title: 'Салат Цезарь',
        description: 'Классический салат с курицей, сухариками и соусом цезарь.',
        imageUrl: 'https://s1.eda.ru/StaticContent/Photos/120213175402/120213175651/p_O.jpg',
        calories: 320.0,
        proteins: 20.0,
        fats: 18.0,
        carbs: 10.0,
      ),
    ];

    if (query.isEmpty) return allRecipes;
    
    return allRecipes.where((r) => r.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}

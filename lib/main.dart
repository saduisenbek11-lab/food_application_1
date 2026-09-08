import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/usecases/get_counter_usecase.dart';
import 'features/counter/domain/usecases/increment_counter_usecase.dart';
import 'features/counter/presentation/manager/counter_notifier.dart';
import 'features/recipes/data/datasources/recipe_mock_data_source.dart';
import 'features/recipes/data/repositories/recipe_repository_impl.dart';
import 'features/recipes/domain/usecases/get_recipes_usecase.dart';
import 'features/recipes/presentation/manager/recipes_notifier.dart';
import 'features/recipes/presentation/pages/recipes_page.dart';
import 'features/core/presentation/theme/app_colors.dart';

void main() {
  // Manual Dependency Injection

  // Counter Feature
  final counterRepository = CounterRepositoryImpl();
  final getCounterUseCase = GetCounterUseCase(counterRepository);
  final incrementCounterUseCase = IncrementCounterUseCase(counterRepository);
  final counterNotifier = CounterNotifier(
    getCounterUseCase: getCounterUseCase,
    incrementCounterUseCase: incrementCounterUseCase,
  );

  // Recipes Feature
  // Используем MockDataSource, пока API Edarix недоступно или есть проблемы с CORS
  final remoteDataSource = RecipeMockDataSourceImpl();
  final recipeRepository = RecipeRepositoryImpl(remoteDataSource);
  final getRecipesUseCase = GetRecipesUseCase(recipeRepository);
  final recipesNotifier = RecipesNotifier(getRecipesUseCase);

  runApp(MyApp(
    counterNotifier: counterNotifier,
    recipesNotifier: recipesNotifier,
  ));
}

class MyApp extends StatelessWidget {
  final CounterNotifier counterNotifier;
  final RecipesNotifier recipesNotifier;

  const MyApp({
    super.key,
    required this.counterNotifier,
    required this.recipesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: RecipesPage(notifier: recipesNotifier),
    );
  }
}

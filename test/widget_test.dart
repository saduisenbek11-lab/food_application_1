// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';
import 'package:untitled/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:untitled/features/counter/domain/usecases/get_counter_usecase.dart';
import 'package:untitled/features/counter/domain/usecases/increment_counter_usecase.dart';
import 'package:untitled/features/counter/presentation/manager/counter_notifier.dart';
import 'package:untitled/features/recipes/data/datasources/recipe_mock_data_source.dart';
import 'package:untitled/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:untitled/features/recipes/domain/usecases/get_recipes_usecase.dart';
import 'package:untitled/features/recipes/presentation/manager/recipes_notifier.dart';

void main() {
  testWidgets('App starts and shows recipes page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final counterRepository = CounterRepositoryImpl();
    final getCounterUseCase = GetCounterUseCase(counterRepository);
    final incrementCounterUseCase = IncrementCounterUseCase(counterRepository);
    final counterNotifier = CounterNotifier(
      getCounterUseCase: getCounterUseCase,
      incrementCounterUseCase: incrementCounterUseCase,
    );

    final recipeDataSource = RecipeMockDataSourceImpl();
    final recipeRepository = RecipeRepositoryImpl(recipeDataSource);
    final getRecipesUseCase = GetRecipesUseCase(recipeRepository);
    final recipesNotifier = RecipesNotifier(getRecipesUseCase);

    await tester.pumpWidget(MyApp(
      counterNotifier: counterNotifier,
      recipesNotifier: recipesNotifier,
    ));

    // Wait for the mock delay
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify that RecipesPage is shown
    expect(find.text('Рецепты Edarix'), findsOneWidget);
    
    // Verify that at least one recipe from mock is shown
    expect(find.text('Борщ классический'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import '../manager/recipes_notifier.dart';

class RecipesPage extends StatefulWidget {
  final RecipesNotifier notifier;

  const RecipesPage({super.key, required this.notifier});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_rebuild);
    // Загружаем рецепты при открытии страницы
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.notifier.loadRecipes();
    });
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final notifier = widget.notifier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты Edarix'),
      ),
      body: _buildBody(notifier),
    );
  }

  Widget _buildBody(RecipesNotifier notifier) {
    if (notifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${notifier.error}'),
            ElevatedButton(
              onPressed: notifier.loadRecipes,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (notifier.recipes.isEmpty) {
      return const Center(child: Text('Нет доступных рецептов'));
    }

    return ListView.builder(
      itemCount: notifier.recipes.length,
      itemBuilder: (context, index) {
        final recipe = notifier.recipes[index];
        return ListTile(
          leading: recipe.imageUrl.isNotEmpty
              ? Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.restaurant),
          title: Text(recipe.title),
          subtitle: Text('${recipe.calories} ккал | Б: ${recipe.proteins} Ж: ${recipe.fats} У: ${recipe.carbs}'),
          onTap: () {
            // Можно добавить переход на детали
          },
        );
      },
    );
  }
}

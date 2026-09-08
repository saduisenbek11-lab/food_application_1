import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../hooks/recipes_hook.dart';
import '../components/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) => context.read<RecipesCubit>().search(value),
                  decoration: InputDecoration(
                    hintText: 'Поиск рецептов...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => context.read<RecipesCubit>().search(''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Подборки',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = state.categories[index];
                        final isActive = state.activeCategoryId == cat.id;
                        return FilterChip(
                          label: Text('${cat.emoji} ${cat.label}'),
                          selected: isActive,
                          onSelected: (_) => context.read<RecipesCubit>().selectCategory(cat.id),
                          backgroundColor: Colors.white,
                          selectedColor: Colors.amber[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.searchQuery.isNotEmpty
                              ? 'Результаты поиска'
                              : (state.activeCategoryId != null
                                  ? state.categories
                                      .firstWhere((c) => c.id == state.activeCategoryId)
                                      .label
                                  : 'Рекомендуем'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (!state.loading && state.error == null)
                          Text(
                            '${state.recipes.length} блюд',
                            style: const TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (state.loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: Colors.amber)),
              )
            else if (state.error != null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      ElevatedButton(
                        onPressed: () => context.read<RecipesCubit>().retry(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              )
            else if (state.recipes.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('Ничего не найдено')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final recipe = state.recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          // TODO: Navigate to details
                        },
                      );
                    },
                    childCount: state.recipes.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

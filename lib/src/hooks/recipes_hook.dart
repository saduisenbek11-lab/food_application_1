import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/recipe.dart';
import '../models/category.dart';
import '../services/recipe_service.dart';

class RecipesState extends Equatable {
  final List<RecipeCategory> categories;
  final List<Recipe> recipes;
  final bool loading;
  final String? error;
  final String? activeCategoryId;
  final String searchQuery;

  const RecipesState({
    this.categories = const [],
    this.recipes = const [],
    this.loading = true,
    this.error,
    this.activeCategoryId,
    this.searchQuery = '',
  });

  RecipesState copyWith({
    List<RecipeCategory>? categories,
    List<Recipe>? recipes,
    bool? loading,
    String? error,
    String? activeCategoryId,
    bool clearActiveCategory = false,
    String? searchQuery,
  }) {
    return RecipesState(
      categories: categories ?? this.categories,
      recipes: recipes ?? this.recipes,
      loading: loading ?? this.loading,
      error: error,
      activeCategoryId: clearActiveCategory ? null : (activeCategoryId ?? this.activeCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [categories, recipes, loading, error, activeCategoryId, searchQuery];
}

class RecipesCubit extends Cubit<RecipesState> {
  final RecipeService service;

  RecipesCubit(this.service) : super(const RecipesState()) {
    init();
  }

  Future<void> init() async {
    final categories = await service.getCategories();
    emit(state.copyWith(categories: categories));
    loadRandom();
  }

  Future<void> loadRandom() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final recipes = await service.getRandomRecipes(10);
      emit(state.copyWith(loading: false, recipes: recipes));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Не удалось загрузить рецепты.'));
    }
  }

  Future<void> selectCategory(String? categoryId) async {
    if (categoryId == state.activeCategoryId) categoryId = null;

    emit(state.copyWith(
      activeCategoryId: categoryId,
      clearActiveCategory: categoryId == null,
      searchQuery: '',
      loading: true,
      error: null,
    ));

    try {
      if (categoryId != null) {
        final recipes = await service.getRecipesByCategory(categoryId);
        emit(state.copyWith(loading: false, recipes: recipes));
      } else {
        await loadRandom();
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Не удалось загрузить подборку.'));
    }
  }

  Future<void> search(String query) async {
    emit(state.copyWith(
      searchQuery: query,
      activeCategoryId: null,
      clearActiveCategory: true,
      loading: query.trim().isNotEmpty,
      error: null,
    ));

    if (query.trim().isEmpty) {
      await loadRandom();
      return;
    }

    try {
      final recipes = await service.searchRecipes(query);
      emit(state.copyWith(loading: false, recipes: recipes));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Поиск не удался.'));
    }
  }

  void retry() {
    if (state.activeCategoryId != null) {
      selectCategory(state.activeCategoryId);
    } else if (state.searchQuery.isNotEmpty) {
      search(state.searchQuery);
    } else {
      loadRandom();
    }
  }
}

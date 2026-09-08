import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/favorites_service.dart';

class FavoritesState extends Equatable {
  final List<String> favorites;
  const FavoritesState({this.favorites = const []});
  @override
  List<Object?> get props => [favorites];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService service;

  FavoritesCubit(this.service) : super(const FavoritesState()) {
    _load();
  }

  Future<void> _load() async {
    final favorites = await service.getFavorites();
    emit(FavoritesState(favorites: favorites));
  }

  Future<void> toggleFavorite(String id) async {
    await service.toggleFavorite(id);
    final favorites = await service.getFavorites();
    emit(FavoritesState(favorites: favorites));
  }

  bool isFavorite(String id) => state.favorites.contains(id);
}

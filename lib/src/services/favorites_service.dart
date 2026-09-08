import '../api/favorites_db.dart';

class FavoritesService {
  final FavoritesDb db;

  FavoritesService({required this.db});

  Future<List<String>> getFavorites() {
    return db.getFavorites();
  }

  Future<void> toggleFavorite(String id) async {
    final favorites = await db.getFavorites();
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await db.saveFavorites(favorites);
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await db.getFavorites();
    return favorites.contains(id);
  }
}

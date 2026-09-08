import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesDb {
  final SharedPreferences sharedPreferences;
  static const _key = 'recipe-app-favorites';

  FavoritesDb({required this.sharedPreferences});

  Future<List<String>> getFavorites() async {
    final stored = sharedPreferences.getString(_key);
    if (stored != null) {
      try {
        return List<String>.from(json.decode(stored));
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    await sharedPreferences.setString(_key, json.encode(favorites));
  }
}

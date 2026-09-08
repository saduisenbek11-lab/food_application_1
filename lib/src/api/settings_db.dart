import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

class SettingsDb {
  final SharedPreferences sharedPreferences;
  static const _key = 'recipe-app-settings';

  SettingsDb({required this.sharedPreferences});

  Future<AppSettings> getSettings() async {
    final stored = sharedPreferences.getString(_key);
    if (stored != null) {
      try {
        return AppSettings.fromJson(json.decode(stored));
      } catch (_) {
        return const AppSettings();
      }
    }
    return const AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await sharedPreferences.setString(_key, json.encode(settings.toJson()));
  }
}

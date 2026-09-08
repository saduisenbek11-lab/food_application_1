import '../api/settings_db.dart';
import '../models/settings.dart';

class SettingsService {
  final SettingsDb db;

  SettingsService({required this.db});

  Future<AppSettings> getSettings() {
    return db.getSettings();
  }

  Future<void> updateSettings(AppSettings settings) {
    return db.saveSettings(settings);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/settings.dart';
import '../services/settings_service.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsService service;

  SettingsCubit(this.service) : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final settings = await service.getSettings();
    emit(settings);
  }

  Future<void> updateSettings({
    AppThemeMode? theme,
    bool? notifications,
    MeasurementUnit? measurementUnit,
    Language? language,
  }) async {
    final newState = state.copyWith(
      theme: theme,
      notifications: notifications,
      measurementUnit: measurementUnit,
      language: language,
    );
    emit(newState);
    await service.updateSettings(newState);
  }
}

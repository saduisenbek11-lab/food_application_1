import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark }
enum MeasurementUnit { metric, imperial }
enum Language { ru, en }

class AppSettings extends Equatable {
  final AppThemeMode theme;
  final bool notifications;
  final MeasurementUnit measurementUnit;
  final Language language;

  const AppSettings({
    this.theme = AppThemeMode.light,
    this.notifications = true,
    this.measurementUnit = MeasurementUnit.metric,
    this.language = Language.ru,
  });

  AppSettings copyWith({
    AppThemeMode? theme,
    bool? notifications,
    MeasurementUnit? measurementUnit,
    Language? language,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      language: language ?? this.language,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: AppThemeMode.values.firstWhere((e) => e.name == json['theme'], orElse: () => AppThemeMode.light),
      notifications: json['notifications'] ?? true,
      measurementUnit: MeasurementUnit.values.firstWhere((e) => e.name == json['measurementUnit'], orElse: () => MeasurementUnit.metric),
      language: Language.values.firstWhere((e) => e.name == json['language'], orElse: () => Language.ru),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.name,
      'notifications': notifications,
      'measurementUnit': measurementUnit.name,
      'language': language.name,
    };
  }

  @override
  List<Object?> get props => [theme, notifications, measurementUnit, language];
}

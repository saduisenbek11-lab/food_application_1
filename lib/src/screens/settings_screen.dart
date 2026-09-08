import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/settings.dart';
import '../hooks/settings_hook.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Настройки'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Оформление'),
              _buildThemeToggle(context, state),
              const SizedBox(height: 24),
              _buildSectionTitle('Уведомления'),
              _buildNotificationToggle(context, state),
              const SizedBox(height: 24),
              _buildSectionTitle('Единицы измерения'),
              _buildUnitToggle(context, state),
              const SizedBox(height: 24),
              _buildSectionTitle('Язык'),
              _buildLanguageToggle(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Гость',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Войдите, чтобы синхронизировать рецепты',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, AppSettings state) {
    return Row(
      children: [
        Expanded(
          child: _ThemeButton(
            label: 'Светлая',
            icon: Icons.light_mode,
            isActive: state.theme == AppThemeMode.light,
            onTap: () => context.read<SettingsCubit>().updateSettings(theme: AppThemeMode.light),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ThemeButton(
            label: 'Тёмная',
            icon: Icons.dark_mode,
            isActive: state.theme == AppThemeMode.dark,
            onTap: () => context.read<SettingsCubit>().updateSettings(theme: AppThemeMode.dark),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle(BuildContext context, AppSettings state) {
    return SwitchListTile(
      title: const Text('Push-уведомления'),
      subtitle: const Text('Советы и напоминания о новых рецептах'),
      value: state.notifications,
      onChanged: (val) => context.read<SettingsCubit>().updateSettings(notifications: val),
      activeColor: Colors.amber,
    );
  }

  Widget _buildUnitToggle(BuildContext context, AppSettings state) {
    return SegmentedButton<MeasurementUnit>(
      segments: const [
        ButtonSegment(value: MeasurementUnit.metric, label: Text('Метрические')),
        ButtonSegment(value: MeasurementUnit.imperial, label: Text('Имперские')),
      ],
      selected: {state.measurementUnit},
      onSelectionChanged: (val) => context.read<SettingsCubit>().updateSettings(measurementUnit: val.first),
    );
  }

  Widget _buildLanguageToggle(BuildContext context, AppSettings state) {
    return SegmentedButton<Language>(
      segments: const [
        ButtonSegment(value: Language.ru, label: Text('Русский')),
        ButtonSegment(value: Language.en, label: Text('English')),
      ],
      selected: {state.language},
      onSelectionChanged: (val) => context.read<SettingsCubit>().updateSettings(language: val.first),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.black54, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

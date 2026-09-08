import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/api/recipe_api.dart';
import 'src/api/favorites_db.dart';
import 'src/api/settings_db.dart';
import 'src/models/settings.dart';
import 'src/services/recipe_service.dart';
import 'src/services/favorites_service.dart';
import 'src/services/settings_service.dart';
import 'src/hooks/recipes_hook.dart';
import 'src/hooks/favorites_hook.dart';
import 'src/hooks/settings_hook.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/favorites_screen.dart';
import 'src/screens/settings_screen.dart';
import 'src/components/bottom_nav.dart';

class App extends StatefulWidget {
  final SharedPreferences prefs;
  const App({super.key, required this.prefs});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => RecipeApi(
            dio: Dio(BaseOptions(baseUrl: 'https://www.themealdb.com/api/json/v1/1')),
          ),
        ),
        RepositoryProvider(
          create: (context) => RecipeService(api: context.read<RecipeApi>()),
        ),
        RepositoryProvider(
          create: (_) => FavoritesDb(sharedPreferences: widget.prefs),
        ),
        RepositoryProvider(
          create: (context) => FavoritesService(db: context.read<FavoritesDb>()),
        ),
        RepositoryProvider(
          create: (_) => SettingsDb(sharedPreferences: widget.prefs),
        ),
        RepositoryProvider(
          create: (context) => SettingsService(db: context.read<SettingsDb>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RecipesCubit(context.read<RecipeService>()),
          ),
          BlocProvider(
            create: (context) => FavoritesCubit(context.read<FavoritesService>()),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(context.read<SettingsService>()),
          ),
        ],
        child: BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, settingsState) {
            return MaterialApp(
              title: 'Recipe App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.amber,
                  brightness: settingsState.theme == AppThemeMode.dark
                      ? Brightness.dark
                      : Brightness.light,
                ),
              ),
              home: Scaffold(
                body: IndexedStack(
                  index: _currentIndex,
                  children: const [
                    HomeScreen(),
                    FavoritesScreen(),
                    SettingsScreen(),
                  ],
                ),
                bottomNavigationBar: BottomNav(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

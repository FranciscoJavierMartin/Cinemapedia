import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  bool isDarkMode = true;

  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    state = state.copyWith(isDarkMode: isDarkMode);
  }
}

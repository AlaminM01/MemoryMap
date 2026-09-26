import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/storage_service.dart';

class ThemeState {
  final ThemeMode themeMode;
  final bool isAmoled;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isAmoled = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isAmoled,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isAmoled: isAmoled ?? this.isAmoled,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final StorageService _storageService;

  ThemeNotifier([StorageService? storageService])
      : _storageService = storageService ?? StorageService(),
        super(const ThemeState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final box = _storageService.settingsBox;
    final modeIndex = box.get(AppConstants.themeModeKey, defaultValue: ThemeMode.system.index) as int;
    final isAmoled = box.get(AppConstants.isAmoledKey, defaultValue: false) as bool;

    state = ThemeState(
      themeMode: ThemeMode.values[modeIndex],
      isAmoled: isAmoled,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _storageService.settingsBox.put(AppConstants.themeModeKey, mode.index);
  }

  Future<void> toggleAmoled(bool value) async {
    state = state.copyWith(isAmoled: value);
    await _storageService.settingsBox.put(AppConstants.isAmoledKey, value);
  }

  ThemeData get activeDarkTheme => state.isAmoled ? AppTheme.amoledTheme : AppTheme.darkTheme;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

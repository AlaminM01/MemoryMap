import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

extension ThemeContextX on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get dynamicBackground =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  Color get dynamicSurface =>
      isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;

  Color get dynamicBorder =>
      isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;

  Color get dynamicTextPrimary =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get dynamicTextSecondary =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
}

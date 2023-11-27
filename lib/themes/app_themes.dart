import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppThemes {
  static get themeMode => DateTime.now().hour > 6 && DateTime.now().hour < 18
      ? ThemeMode.light
      : ThemeMode.dark;

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      background: AppColors.backgroundDay,
      surface: AppColors.containerDay,
      onBackground: AppColors.textDay,
      onSurface: AppColors.textDay,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textDay,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textDay,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: AppColors.textDay,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      background: AppColors.backgroundNight,
      surface: AppColors.containerNight,
      onBackground: AppColors.textNight,
      onSurface: AppColors.textNight,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textNight,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textNight,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: AppColors.textNight,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

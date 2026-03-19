import 'package:flutter/material.dart';
import 'package:flutter_base_app/app/ui/theme/app_colors.dart';
import 'package:flutter_base_app/app/ui/theme/app_text_styles.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'AppFont',
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      titleTextStyle: AppTextStyles.heading2,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: 'AppFont',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
  );
}

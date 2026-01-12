import 'package:casetracking/core/consts/appcolors.dart';
import 'package:flutter/material.dart';

ThemeData appTheme(isTablet) {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: isTablet ? 18 : 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: isTablet ? 16 : 14,
      ),
      bodySmall: TextStyle(
        color: AppColors.textHint,
        fontSize: isTablet ? 14 : 12,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

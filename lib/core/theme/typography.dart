import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme = const TextTheme(
    headlineSmall: TextStyle(fontWeight: FontWeight.w700),
    titleLarge:    TextStyle(fontWeight: FontWeight.w600),
    titleMedium:   TextStyle(fontWeight: FontWeight.w600),
    bodyMedium:    TextStyle(fontWeight: FontWeight.w400),
    labelLarge:    TextStyle(fontWeight: FontWeight.w600),
  );
}

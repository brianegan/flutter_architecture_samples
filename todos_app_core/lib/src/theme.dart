import 'package:flutter/material.dart';

class ArchSampleTheme {
  static ThemeData get lightTheme {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyanAccent,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyanAccent,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}

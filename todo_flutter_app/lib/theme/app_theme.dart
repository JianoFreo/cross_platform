import 'package:flutter/material.dart';

class AppTheme {
  static final Map<String, ThemeData> themes = {
    'Blue': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
    ),
    'Green': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
    ),
    'Yellow': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow,
        brightness: Brightness.light,
        onPrimary: Colors.black,
      ),
    ),
    'Red': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: Brightness.light,
      ),
    ),
    'Brown': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
        brightness: Brightness.light,
      ),
    ),
    'Dark': ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey.shade900,
        brightness: Brightness.dark,
      ),
    ),
  };
}
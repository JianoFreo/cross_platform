import 'package:flutter/material.dart';

class AppTheme {
  static final Map<String, ThemeData> themes = {
    'Blue': ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.blue[50],
      appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
    ),
    'Green': ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.green[50],
      appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.green),
    ),
    'Red': ThemeData(
      primarySwatch: Colors.red,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.red[50],
      appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.red),
    ),
    'Yellow': ThemeData(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.yellow[50],
      appBarTheme: const AppBarTheme(backgroundColor: Colors.orange),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.orange),
    ),
    'Brown': ThemeData(
      primarySwatch: Colors.brown,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.brown[50],
      appBarTheme: const AppBarTheme(backgroundColor: Colors.brown),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.brown),
    ),
    'Dark': ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: const AppBarTheme(backgroundColor: Colors.grey),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.grey),
    ),
  };
}
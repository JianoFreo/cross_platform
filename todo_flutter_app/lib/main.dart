import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  ThemeData _currentTheme = AppTheme.themes['Blue']!;

  void updateTheme(String themeName) {
    setState(() {
      _currentTheme = AppTheme.themes[themeName]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: _currentTheme,
      home: HomeScreen(onThemeChange: updateTheme),
    );
  }
}
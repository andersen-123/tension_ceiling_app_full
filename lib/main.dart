import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Добавьте этот импорт

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сметы потолков',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Теперь используем реальный HomeScreen
      home: const HomeScreen(),
    );
  }
}

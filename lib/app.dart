import 'app.dart'; // Добавьте эту строку
import 'package:flutter/material.dart';
// Временно удаляем несуществующие импорты

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Смета потолков',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Временные маршруты-заглушки для сборки
      routes: {
        '/': (context) => const Scaffold(body: Center(child: Text('Главная'))),
        '/estimates': (context) => const Scaffold(body: Center(child: Text('Сметы'))),
        '/templates': (context) => const Scaffold(body: Center(child: Text('Шаблоны'))),
        '/calculator': (context) => const Scaffold(body: Center(child: Text('Калькулятор'))),
        '/history': (context) => const Scaffold(body: Center(child: Text('История'))),
        '/settings': (context) => const Scaffold(body: Center(child: Text('Настройки'))),
        '/estimate/edit': (context) => const Scaffold(body: Center(child: Text('Редактирование'))),
      },
      initialRoute: '/',
    );
  }
}

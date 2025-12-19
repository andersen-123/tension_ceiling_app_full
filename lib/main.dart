import 'package:flutter/material.dart';
import 'models/estimate.dart';
import 'models/estimate_item.dart';

// ТЕСТОВАЯ ФУНКЦИЯ - проверяем логику до запуска приложения
void _testLogic() {
  print('=== НАЧАЛО ТЕСТА ЛОГИКИ ===');

  // 1. Создаем тестовые позиции
  final item1 = EstimateItem(
    id: '1',
    name: 'Полотно натяжное',
    unit: 'м²',
    price: 1200.0,
    quantity: 10.5,
  );

  final item2 = EstimateItem(
    id: '2',
    name: 'Монтаж профиля',
    unit: 'м.п.',
    price: 500.0,
    quantity: 15.0,
  );

  print('Позиция 1: $item1');
  print('Позиция 2: $item2');

  // 2. Создаем смету
  final estimate = Estimate(
    id: 'test-001',
    title: 'Тестовая смета',
    customerName: 'Иванов Иван',
    createdAt: DateTime.now(),
    items: [item1, item2],
  );

  print('Создана смета: $estimate');
  print('Общая сумма: ${estimate.total} руб.');

  // 3. Тестируем toMap/fromMap
  print('\n--- Тест toMap/fromMap ---');
  final map = estimate.toMap();
  print('Смета как Map: $map');

  final restoredEstimate = Estimate.fromMap(map);
  print('Восстановленная смета: $restoredEstimate');
  print('Сумма восстановленной: ${restoredEstimate.total} руб.');

  // 4. Тестируем добавление/удаление
  print('\n--- Тест добавления/удаления ---');
  final item3 = EstimateItem(
    id: '3',
    name: 'Дополнительная работа',
    unit: 'шт.',
    price: 3000.0,
    quantity: 2.0,
  );

  estimate.addItem(item3);
  print('После добавления: ${estimate.total} руб.');

  estimate.removeItem('1');
  print('После удаления id=1: ${estimate.total} руб.');

  print('=== ТЕСТ ЗАВЕРШЕН ===\n');
}

void main() {
  // Запускаем тест перед инициализацией Flutter
  _testLogic();

  // Запускаем приложение
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сметы потолков - Этап 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Этап 1: Логика готова'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 64, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Логика моделей работает!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Проверьте логи в консоли запуска (в терминале или логах GitHub Actions). Вы должны увидеть результаты тестовых расчетов.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

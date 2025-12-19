import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/estimate.dart';
import 'models/estimate_item.dart';

// ТЕСТОВАЯ ФУНКЦИЯ - проверяем работу с базой данных
Future<void> _testDatabase() async {
  print('\n=== НАЧАЛО ТЕСТА БАЗЫ ДАННЫХ ===');

  // Инициализируем помощник БД
  final dbHelper = DatabaseHelper();

  // 1. Создаём тестовую смету
  final testEstimate = Estimate(
    id: 'db-test-${DateTime.now().millisecondsSinceEpoch}',
    title: 'Смета из теста БД',
    customerName: 'Тестовый клиент',
    notes: 'Это тестовая смета для проверки работы базы данных',
    createdAt: DateTime.now(),
    items: [
      EstimateItem(
        id: 'item-1',
        name: 'Натяжной потолок',
        unit: 'м²',
        price: 1250.0,
        quantity: 15.5,
      ),
      EstimateItem(
        id: 'item-2',
        name: 'Установка люстры',
        unit: 'шт.',
        price: 800.0,
        quantity: 1.0,
      ),
    ],
  );

  print('📝 Создана тестовая смета:');
  print('   Название: ${testEstimate.title}');
  print('   Клиент: ${testEstimate.customerName}');
  print('   Сумма: ${testEstimate.total} руб.');

  try {
    // 2. СОХРАНЯЕМ смету в БД
    print('\n💾 Сохраняю смету в базу данных...');
    await dbHelper.insertEstimate(testEstimate);
    print('✅ Смета сохранена успешно!');

    // 3. ЗАГРУЖАЕМ ВСЕ сметы из БД
    print('\n📋 Загружаю все сметы из базы...');
    final allEstimates = await dbHelper.getAllEstimates();
    print('✅ Загружено смет: ${allEstimates.length}');

    for (final estimate in allEstimates) {
      print('   • ${estimate.title} (${estimate.total} руб.)');
    }

    // 4. ЗАГРУЖАЕМ КОНКРЕТНУЮ смету по ID
    print('\n🔍 Загружаю конкретную смету по ID...');
    final loadedEstimate = await dbHelper.getEstimate(testEstimate.id);
    
    if (loadedEstimate != null) {
      print('✅ Смета найдена!');
      print('   Название: ${loadedEstimate.title}');
      print('   Позиций: ${loadedEstimate.items.length}');
      print('   Итог: ${loadedEstimate.total} руб.');
      
      // Проверяем, что позиции загрузились
      for (final item in loadedEstimate.items) {
        print('      - ${item.name}: ${item.quantity} ${item.unit} × ${item.price} руб. = ${item.total} руб.');
      }
    } else {
      print('❌ Смета не найдена!');
    }

    // 5. ОБНОВЛЯЕМ смету
    print('\n✏️ Обновляю смету...');
    testEstimate.notes = 'Обновлённые заметки из теста';
    await dbHelper.updateEstimate(testEstimate);
    print('✅ Смета обновлена!');

    // 6. УДАЛЯЕМ смету
    print('\n🗑️ Удаляю тестовую смету...');
    await dbHelper.deleteEstimate(testEstimate.id);
    print('✅ Смета удалена!');

    // 7. Проверяем, что удалилось
    final remainingEstimates = await dbHelper.getAllEstimates();
    print('\n📊 Осталось смет в базе: ${remainingEstimates.length}');

  } catch (e) {
    print('❌ ОШИБКА в тесте базы данных: $e');
  }

  print('=== ТЕСТ БАЗЫ ДАННЫХ ЗАВЕРШЕН ===\n');
}

void main() async {
  // Запускаем тест базы данных ПЕРЕД запуском приложения
  WidgetsFlutterBinding.ensureInitialized();
  await _testDatabase();

  // Запускаем приложение
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Сметы потолков - Этап 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Этап 2: База данных готова'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storage, size: 64, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'База данных работает!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Проверьте логи в консоли (терминал или GitHub Actions). Вы должны увидеть полный тест работы с SQLite: создание, сохранение, загрузку и удаление смет.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '✅ Этап 2 завершён',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

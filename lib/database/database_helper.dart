import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/estimate.dart';

class DatabaseHelper {
  // 1. Синглтон (один экземпляр на всё приложение)
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // 2. Геттер для базы данных (создаёт, если ещё нет)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 3. Инициализация базы данных
  Future<Database> _initDatabase() async {
    // Путь к базе данных в файловой системе устройства
    String path = join(await getDatabasesPath(), 'estimates_database.db');
    print('📂 Путь к БД: $path');

    // Создание/открытие базы данных
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // 4. Создание таблицы при первом запуске
  Future<void> _onCreate(Database db, int version) async {
    print('🆕 Создаю таблицу "estimates"...');
    await db.execute('''
      CREATE TABLE estimates (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        customerName TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL,
        items TEXT NOT NULL,
        total REAL NOT NULL
      )
    ''');
    print('✅ Таблица "estimates" создана');
  }

  // ==================== ОСНОВНЫЕ МЕТОДЫ (CRUD) ====================

  // 5. СОХРАНЕНИЕ новой сметы
  Future<int> insertEstimate(Estimate estimate) async {
    final db = await database;
    print('💾 Сохраняю смету: ${estimate.title}');
    
    try {
      // Используем toMap, который мы написали в Estimate
      final id = await db.insert(
        'estimates',
        estimate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('✅ Смета сохранена с ID: $id');
      return id;
    } catch (e) {
      print('❌ Ошибка при сохранении: $e');
      rethrow;
    }
  }

  // 6. ПОЛУЧЕНИЕ ВСЕХ смет
  Future<List<Estimate>> getAllEstimates() async {
    final db = await database;
    print('📋 Загружаю все сметы...');
    
    final List<Map<String, dynamic>> maps = await db.query('estimates');
    print('✅ Найдено смет: ${maps.length}');
    
    // Преобразуем каждую Map в объект Estimate
    return List.generate(maps.length, (i) {
      return Estimate.fromMap(maps[i]);
    });
  }

  // 7. ПОЛУЧЕНИЕ ОДНОЙ сметы по ID
  Future<Estimate?> getEstimate(String id) async {
    final db = await database;
    print('🔍 Ищу смету с ID: $id');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'estimates',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) {
      print('⚠️ Смета с ID $id не найдена');
      return null;
    }
    
    print('✅ Смета найдена: ${maps.first['title']}');
    return Estimate.fromMap(maps.first);
  }

  // 8. ОБНОВЛЕНИЕ сметы
  Future<int> updateEstimate(Estimate estimate) async {
    final db = await database;
    print('✏️ Обновляю смету: ${estimate.title}');
    
    return await db.update(
      'estimates',
      estimate.toMap(),
      where: 'id = ?',
      whereArgs: [estimate.id],
    );
  }

  // 9. УДАЛЕНИЕ сметы
  Future<int> deleteEstimate(String id) async {
    final db = await database;
    print('🗑️ Удаляю смету с ID: $id');
    
    return await db.delete(
      'estimates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 10. УДАЛЕНИЕ ВСЕХ смет (для тестов)
  Future<void> deleteAllEstimates() async {
    final db = await database;
    print('🧹 Удаляю все сметы...');
    await db.delete('estimates');
    print('✅ Все сметы удалены');
  }

  // 11. Закрытие базы данных (для завершения работы)
  Future<void> close() async {
    final db = await database;
    await db.close();
    print('🔒 База данных закрыта');
  }
}

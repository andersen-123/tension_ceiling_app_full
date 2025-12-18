import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/estimate.dart';
import '../models/estimate_item.dart';

class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'estimates.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE estimates(
            id TEXT PRIMARY KEY,
            number TEXT NOT NULL,
            created_at TEXT NOT NULL,
            client_name TEXT NOT NULL,
            address TEXT NOT NULL,
            object_type TEXT NOT NULL,
            rooms INTEGER NOT NULL,
            area REAL NOT NULL,
            perimeter REAL NOT NULL,
            height REAL NOT NULL,
            total REAL NOT NULL,
            status TEXT NOT NULL,
            is_template INTEGER NOT NULL,
            notes TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE estimate_items(
            id TEXT PRIMARY KEY,
            estimate_id TEXT NOT NULL,
            name TEXT NOT NULL,
            unit TEXT NOT NULL,
            quantity REAL NOT NULL,
            price REAL NOT NULL,
            total REAL NOT NULL,
            FOREIGN KEY (estimate_id) REFERENCES estimates (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
  
  Future<void> initDatabase() async {
    await database;
  }
  
  Future<int> insertEstimate(Estimate estimate) async {
    final db = await database;
    return await db.insert('estimates', estimate.toMap());
  }
  
  Future<List<Estimate>> getAllEstimates() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('estimates');
    return List.generate(maps.length, (i) {
      return Estimate.fromMap(maps[i]);
    });
  }
  
  Future<Estimate?> getEstimate(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'estimates',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Estimate.fromMap(maps.first);
  }
}

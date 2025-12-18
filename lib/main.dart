import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'database/database_helper.dart';
import 'services/auto_save_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final databaseHelper = DatabaseHelper();
  await databaseHelper.initDatabase();
  
  final autoSaveService = AutoSaveService();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseHelper>(create: (_) => databaseHelper),
        Provider<AutoSaveService>(create: (_) => autoSaveService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PotolokForLife',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

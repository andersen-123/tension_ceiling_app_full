import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const EstimateListScreen(),
    const TemplateScreen(),
    const CalculatorScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];
  
  final List<String> _appBarTitles = [
    'Мои сметы',
    'Шаблоны',
    'Калькулятор',
    'История',
    'Настройки',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_currentIndex]),
        actions: _currentIndex == 0 ? [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstimateEditScreen(),
                ),
              );
            },
          ),
        ] : null,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Сметы'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Шаблоны'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Калькулятор'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сметы натяжных потолков'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Главное меню',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Кнопка для создания новой сметы
            ElevatedButton.icon(
              onPressed: () {
                // Позже здесь будет навигация на экран создания
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция в разработке')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('НОВАЯ СМЕТА'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            // Кнопка для просмотра списка смет
            OutlinedButton.icon(
              onPressed: () {
                // Позже здесь будет навигация на список
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция в разработке')),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('МОИ СМЕТЫ'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
      // Нижняя панель навигации (можно будет добавить позже)
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.calculate), onPressed: () {}),
            IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

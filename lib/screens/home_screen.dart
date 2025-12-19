import 'package:flutter/material.dart';
import 'estimate_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сметы потолков')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Главный экран', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EstimateEditScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('СОЗДАТЬ НОВУЮ СМЕТУ'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/estimate.dart';
import '../models/estimate_item.dart';
import '../database/database_helper.dart';

class EstimateEditScreen extends StatefulWidget {
  final Estimate? existingEstimate;

  const EstimateEditScreen({super.key, this.existingEstimate});

  @override
  State<EstimateEditScreen> createState() => _EstimateEditScreenState();
}

class _EstimateEditScreenState extends State<EstimateEditScreen> {
  // Контроллеры для текстовых полей сметы
  final _titleController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _notesController = TextEditingController();

  // Контроллеры для текстовых полей НОВОЙ позиции (внизу экрана)
  final _newItemNameController = TextEditingController();
  final _newItemUnitController = TextEditingController(text: 'м²');
  final _newItemPriceController = TextEditingController();
  final _newItemQuantityController = TextEditingController(text: '1.0');

  // Список позиций текущей смета
  List<EstimateItem> _items = [];

  // ID сметы (если редактируем существующую)
  String? _estimateId;

  // Помощник для работы с БД
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    // Если передан существующий объект Estimate, заполняем форму его данными
    if (widget.existingEstimate != null) {
      final estimate = widget.existingEstimate!;
      _estimateId = estimate.id;
      _titleController.text = estimate.title;
      _customerNameController.text = estimate.customerName ?? '';
      _notesController.text = estimate.notes ?? '';
      _items = List.from(estimate.items);
    } else {
      // Иначе создаём новую смету с уникальным ID
      _estimateId = const Uuid().v4();
    }
  }

  @override
  void dispose() {
    // Важно: освобождаем контроллеры
    _titleController.dispose();
    _customerNameController.dispose();
    _notesController.dispose();
    _newItemNameController.dispose();
    _newItemUnitController.dispose();
    _newItemPriceController.dispose();
    _newItemQuantityController.dispose();
    super.dispose();
  }

  // 1. Метод для добавления новой позиции в список
  void _addNewItem() {
    final name = _newItemNameController.text.trim();
    final unit = _newItemUnitController.text.trim();
    final price = double.tryParse(_newItemPriceController.text) ?? 0.0;
    final quantity = double.tryParse(_newItemQuantityController.text) ?? 1.0;

    if (name.isEmpty || price <= 0) {
      _showSnackBar('Заполните название и цену');
      return;
    }

    setState(() {
      _items.add(EstimateItem(
        id: const Uuid().v4(),
        name: name,
        unit: unit,
        price: price,
        quantity: quantity,
      ));
    });

    // Очищаем поля после добавления
    _newItemNameController.clear();
    _newItemPriceController.clear();
    _newItemQuantityController.text = '1.0';

    // Прячем клавиатуру
    FocusScope.of(context).unfocus();
    _showSnackBar('Позиция добавлена');
  }

  // 2. Метод для удаления позиции
  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _showSnackBar('Позиция удалена');
  }

  // 3. Метод для сохранения всей сметы в базу данных
  Future<void> _saveEstimate() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showSnackBar('Введите название сметы');
      return;
    }

    // Создаём объект Estimate с текущими данными
    final estimate = Estimate(
      id: _estimateId!,
      title: title,
      customerName: _customerNameController.text.isNotEmpty
          ? _customerNameController.text
          : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      createdAt: widget.existingEstimate?.createdAt ?? DateTime.now(),
      items: _items,
    );

    try {
      // Сохраняем в базу данных
      await _dbHelper.insertEstimate(estimate);
      
      // Показываем сообщение об успехе
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingEstimate != null
              ? '✅ Смета обновлена'
              : '✅ Смета сохранена'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Через 1.5 секунды возвращаемся назад
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      Navigator.pop(context, estimate); // Возвращаем обновлённую смету
      
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('❌ Ошибка сохранения: $e');
    }
  }

  // 4. Вспомогательный метод для показа уведомлений
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 5. Вычисляем итоговую сумму ВСЕХ позиций
  double get _totalSum {
    return _items.fold(0.0, (sum, item) => sum + item.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEstimate != null
            ? 'Редактировать смету'
            : 'Новая смета'),
        actions: [
          IconButton(
            onPressed: _saveEstimate,
            icon: const Icon(Icons.save),
            tooltip: 'Сохранить смету',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ========== СЕКЦИЯ 1: Основные данные сметы ==========
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Основные данные',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Название сметы *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя клиента',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Примечания',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ========== СЕКЦИЯ 2: Список добавленных позиций ==========
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Позиции сметы',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ИТОГО: ${_totalSum.toStringAsFixed(2)} ₽',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Количество позиций: ${_items.length}'),
                  const SizedBox(height: 12),

                  // Список добавленных позиций
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.list_alt,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Позиций пока нет',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Добавьте первую позицию ниже',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(
                                      '${item.quantity} ${item.unit} × ${item.price} ₽'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${item.total.toStringAsFixed(2)} ₽',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _removeItem(index),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ========== СЕКЦИЯ 3: Форма добавления НОВОЙ позиции ==========
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Добавить новую позицию',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Название позиции
                        Expanded(
                          child: TextField(
                            controller: _newItemNameController,
                            decoration: const InputDecoration(
                              labelText: 'Название *',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Единица измерения
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _newItemUnitController,
                            decoration: const InputDecoration(
                              labelText: 'Ед.',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Цена за единицу
                        Expanded(
                          child: TextField(
                            controller: _newItemPriceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Цена *',
                              border: OutlineInputBorder(),
                              isDense: true,
                              prefixText: '₽ ',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Количество
                        Expanded(
                          child: TextField(
                            controller: _newItemQuantityController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Кол-во',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Кнопка добавления
                        ElevatedButton.icon(
                          onPressed: _addNewItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Добавить'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'estimate_item.dart';
import 'dart:convert';

class Estimate {
  String id;
  String title;
  String? customerName;
  String? notes;
  DateTime createdAt;
  List<EstimateItem> items;
  double total; // Вычисляемое поле

  Estimate({
    required this.id,
    required this.title,
    this.customerName,
    this.notes,
    required this.createdAt,
    List<EstimateItem>? items,
  })  : items = items ?? [],
        total = 0.0 {
    // Пересчитываем итог при создании
    recalculateTotal();
  }

  // ==================== ОСНОВНЫЕ МЕТОДЫ ====================

  // 1. Пересчет общей суммы
  void recalculateTotal() {
    total = items.fold(0.0, (sum, item) => sum + item.total);
  }

  // 2. Добавление позиции
  void addItem(EstimateItem item) {
    items.add(item);
    total += item.total;
  }

  // 3. Удаление позиции по ID
  void removeItem(String itemId) {
    final itemIndex = items.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      total -= items[itemIndex].total;
      items.removeAt(itemIndex);
    }
  }

  // 4. Обновление позиции
  void updateItem(String itemId, EstimateItem newItem) {
    final itemIndex = items.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      total -= items[itemIndex].total;
      items[itemIndex] = newItem;
      total += newItem.total;
    }
  }

  // ==================== МЕТОДЫ ДЛЯ БАЗЫ ДАННЫХ ====================

  // 5. Конвертация в Map (для сохранения в БД)
  Map<String, dynamic> toMap() {
    // Конвертируем список items в список Map
    final itemsJson = items.map((item) => item.toMap()).toList();

    return {
      'id': id,
      'title': title,
      'customerName': customerName,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'items': jsonEncode(itemsJson), // Сохраняем items как JSON строку
      'total': total,
    };
  }

  // 6. Создание объекта из Map (из БД)
  factory Estimate.fromMap(Map<String, dynamic> map) {
    // Парсим JSON строку с items обратно в список
    List<EstimateItem> itemsList = [];
    if (map['items'] != null) {
      final itemsData = jsonDecode(map['items']) as List;
      itemsList = itemsData.map((itemMap) => EstimateItem.fromMap(itemMap)).toList();
    }

    return Estimate(
      id: map['id'],
      title: map['title'],
      customerName: map['customerName'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      items: itemsList,
    )..total = map['total'].toDouble(); // Восстанавливаем сохраненный total
  }

  // 7. Создание копии (для редактирования)
  Estimate copyWith({
    String? id,
    String? title,
    String? customerName,
    String? notes,
    DateTime? createdAt,
    List<EstimateItem>? items,
  }) {
    return Estimate(
      id: id ?? this.id,
      title: title ?? this.title,
      customerName: customerName ?? this.customerName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items.map((item) => item.copyWith()).toList(),
    );
  }

  // Для отладки
  @override
  String toString() {
    return 'Estimate{title: $title, total: $total, items: ${items.length}}';
  }
}

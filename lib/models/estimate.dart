import 'estimate_item.dart';

class Estimate {
  String id;
  String title;
  DateTime createdAt;
  List<EstimateItem> items;
  double total;

  Estimate({
    required this.id,
    required this.title,
    required this.createdAt,
    List<EstimateItem>? items,
    double? total,
  })  : items = items ?? [],
        total = total ?? (items?.fold(0.0, (sum, item) => sum + item.total) ?? 0.0);

  // Конвертируем объект в Map для сохранения в БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      // items и total вычисляются, могут не храниться в БД
    };
  }

  // Создаем объект из Map, полученного из БД
  factory Estimate.fromMap(Map<String, dynamic> map) {
    return Estimate(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['createdAt']),
      // Если в БД хранятся items, нужно их парсить отдельно
      items: [], // Временная заглушка. Позже добавите логику.
      total: 0.0, // Временная заглушка. Позже вычислите.
    );
  }

  void addItem(EstimateItem item) {
    items.add(item);
    total += item.total;
  }

  void removeItem(String itemId) {
    final item = items.firstWhere((item) => item.id == itemId);
    total -= item.total;
    items.removeWhere((item) => item.id == itemId);
  }

  Estimate copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    List<EstimateItem>? items,
    double? total,
  }) {
    return Estimate(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items.map((item) => item.clone()).toList(),
      total: total ?? this.total,
    );
  }
}

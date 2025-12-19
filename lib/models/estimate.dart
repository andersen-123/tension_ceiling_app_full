import 'estimate_item.dart'; // КРИТИЧЕСКИ ВАЖНЫЙ ИМПОРТ

class Estimate {
  String id;
  String title;
  DateTime createdAt;
  List<EstimateItem> items; // Теперь тип распознается
  double total;

  Estimate({
    required this.id,
    required this.title,
    required this.createdAt,
    List<EstimateItem>? items,
    double? total,
  }) : items = items ?? [],
        total = total ?? (items?.fold(0, (sum, item) => sum + item.total) ?? 0);

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

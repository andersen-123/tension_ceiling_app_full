class EstimateItem {
  final String id;
  final String name;
  final String unit;
  final double price;
  double quantity;

  EstimateItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    this.quantity = 1.0,
  });

  // Геттер для вычисления общей стоимости позиции
  double get total => price * quantity;

  // 1. Метод для конвертации в Map (для сохранения в БД)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'price': price,
      'quantity': quantity,
      // total не сохраняем, он вычисляемый
    };
  }

  // 2. Фабричный конструктор для создания объекта из Map (из БД)
  factory EstimateItem.fromMap(Map<String, dynamic> map) {
    return EstimateItem(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      price: map['price'].toDouble(),
      quantity: map['quantity'].toDouble(),
    );
  }

  // 3. Метод для создания копии объекта (полезно для редактирования)
  EstimateItem copyWith({
    String? id,
    String? name,
    String? unit,
    double? price,
    double? quantity,
  }) {
    return EstimateItem(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  // Для отладки
  @override
  String toString() {
    return 'EstimateItem{name: $name, price: $price, quantity: $quantity, total: $total}';
  }
}

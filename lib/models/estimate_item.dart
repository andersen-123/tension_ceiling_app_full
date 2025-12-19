class EstimateItem {
  final String id;
  final String name;
  final double price;
  final double quantity;
  final String unit;

  EstimateItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1.0,
    this.unit = 'шт.',
  });

  double get total => price * quantity;

  EstimateItem clone() {
    return EstimateItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      unit: unit,
    );
  }
}

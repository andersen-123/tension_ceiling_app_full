class EstimateItem {
  String id;
  String name;
  String unit;
  double quantity;
  double price;
  double total;
  
  EstimateItem({
    String? id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.price,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       total = quantity * price;
  
  void updateQuantity(double newQuantity) {
    quantity = newQuantity;
    total = quantity * price;
  }
  
  void updatePrice(double newPrice) {
    price = newPrice;
    total = quantity * price;
  }
  
  EstimateItem clone() {
    return EstimateItem(
      name: name,
      unit: unit,
      quantity: quantity,
      price: price,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
  
  factory EstimateItem.fromMap(Map<String, dynamic> map) {
    return EstimateItem(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}

class Estimate {
  String id;
  String number;
  DateTime createdAt;
  String clientName;
  String address;
  String objectType;
  int rooms;
  double area;
  double perimeter;
  double height;
  List<EstimateItem> items;
  double total;
  String status;
  bool isTemplate;
  String notes;
  
  Estimate({
    String? id,
    required this.clientName,
    required this.address,
    required this.objectType,
    required this.rooms,
    required this.area,
    required this.perimeter,
    required this.height,
    List<EstimateItem>? items,
    this.status = 'draft',
    this.isTemplate = false,
    this.notes = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = DateTime.now(),
       number = 'СМ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
       items = items ?? [],
       total = 0 {
    calculateTotal();
  }
  
  void calculateTotal() {
    total = items.fold(0, (sum, item) => sum + item.total);
  }
  
  void addItem(EstimateItem item) {
    items.add(item);
    calculateTotal();
  }
  
  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    calculateTotal();
  }
  
  Estimate clone() {
    return Estimate(
      clientName: '$clientName (Копия)',
      address: address,
      objectType: objectType,
      rooms: rooms,
      area: area,
      perimeter: perimeter,
      height: height,
      items: items.map((item) => item.clone()).toList(),
      status: 'draft',
      notes: notes,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'created_at': createdAt.toIso8601String(),
      'client_name': clientName,
      'address': address,
      'object_type': objectType,
      'rooms': rooms,
      'area': area,
      'perimeter': perimeter,
      'height': height,
      'total': total,
      'status': status,
      'is_template': isTemplate ? 1 : 0,
      'notes': notes,
    };
  }
  
  factory Estimate.fromMap(Map<String, dynamic> map) {
    return Estimate(
      id: map['id'],
      clientName: map['client_name'],
      address: map['address'],
      objectType: map['object_type'],
      rooms: map['rooms'],
      area: map['area'],
      perimeter: map['perimeter'],
      height: map['height'],
      status: map['status'],
      isTemplate: map['is_template'] == 1,
      notes: map['notes'] ?? '',
    );
  }
}

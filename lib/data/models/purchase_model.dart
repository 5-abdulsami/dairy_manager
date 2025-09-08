// lib/data/models/purchase_model.dart
class Purchase {
  int? id;
  int supplierId;
  String supplierName; // This will come from JOIN queries only
  double quantity;
  double rate;
  double totalAmount;
  DateTime date;
  String productType;
  String unit;

  Purchase({
    this.id,
    required this.supplierId,
    required this.supplierName, // Keep this but handle it properly
    required this.quantity,
    required this.rate,
    required this.totalAmount,
    required this.date,
    required this.productType,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplierId': supplierId,
      'quantity': quantity,
      'rate': rate,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'productType': productType,
      'unit': unit,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      supplierId: map['supplierId'],
      supplierName: map['supplierName'] ?? '', // Keep this for JOIN queries
      quantity: (map['quantity'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      productType: map['productType'],
      unit: map['unit'],
    );
  }

  // Add a factory method for database rows (without supplierName)
  factory Purchase.fromDbMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      supplierId: map['supplierId'],
      supplierName: '', // Will be empty for database rows
      quantity: (map['quantity'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      productType: map['productType'],
      unit: map['unit'],
    );
  }
}

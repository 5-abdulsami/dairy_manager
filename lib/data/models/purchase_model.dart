// lib/data/models/purchase_model.dart
class Purchase {
  int? id;
  int supplierId;
  String supplierName;
  double quantity;
  double rate;
  double totalAmount;
  DateTime date;
  String productType;
  String unit;

  Purchase({
    this.id,
    required this.supplierId,
    required this.supplierName,
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
      supplierName: map['supplierName'] ?? '',
      quantity: map['quantity'],
      rate: map['rate'],
      totalAmount: map['totalAmount'],
      date: DateTime.parse(map['date']),
      productType: map['productType'],
      unit: map['unit'],
    );
  }
}

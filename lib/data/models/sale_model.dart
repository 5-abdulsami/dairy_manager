// lib/data/models/sale_model.dart
class Sale {
  int? id;
  double quantity;
  int rate;
  double totalAmount;
  DateTime date;
  String productType;
  String unit;

  Sale({
    this.id,
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
      'quantity': quantity,
      'rate': rate,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'productType': productType,
      'unit': unit,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      quantity: map['quantity'],
      rate: map['rate'],
      totalAmount: map['totalAmount'],
      date: DateTime.parse(map['date']),
      productType: map['productType'],
      unit: map['unit'],
    );
  }
}

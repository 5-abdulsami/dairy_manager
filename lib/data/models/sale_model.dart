// lib/data/models/sale_model.dart
class Sale {
  int? id;
  int customerId;
  String customerName;
  String shopName;
  double quantity;
  double rate;
  double totalAmount;
  DateTime date;
  String productType;
  String unit;

  Sale({
    this.id,
    required this.customerId,
    required this.customerName,
    required this.shopName,
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
      'customerId': customerId,
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
      customerId: map['customerId'],
      customerName: map['customerName'] ?? '',
      shopName: map['shopName'] ?? '',
      quantity: (map['quantity'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      productType: map['productType'],
      unit: map['unit'],
    );
  }
}

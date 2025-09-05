// lib/data/models/supplier_model.dart
class Supplier {
  int? id;
  String name;
  String? phoneNumber;
  String productType;
  double rate;
  DateTime createdAt;

  Supplier({
    this.id,
    required this.name,
    this.phoneNumber,
    required this.productType,
    required this.rate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'productType': productType,
      'rate': rate,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      productType: map['productType'],
      rate: map['rate'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

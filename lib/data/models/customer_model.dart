// lib/data/models/customer_model.dart
class Customer {
  int? id;
  String name;
  String? phoneNumber;
  String shopName;
  String? address;
  DateTime createdAt;

  Customer({
    this.id,
    required this.name,
    this.phoneNumber,
    required this.shopName,
    this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'shopName': shopName,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      shopName: map['shopName'] ?? '',
      address: map['address'],
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

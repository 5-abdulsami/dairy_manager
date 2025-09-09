import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';

class SupplierReport {
  final Supplier supplier;
  final DateTime startDate;
  final DateTime endDate;
  final List<Purchase> purchases;
  final double totalAmount;
  final int totalTransactions;

  SupplierReport({
    required this.supplier,
    required this.startDate,
    required this.endDate,
    required this.purchases,
    required this.totalAmount,
    required this.totalTransactions,
  });
}

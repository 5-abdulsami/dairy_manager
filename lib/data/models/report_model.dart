// lib/data/models/report_model.dart
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/models/sale_model.dart';

class Report {
  final DateTime startDate;
  final DateTime endDate;
  final double totalPurchases;
  final double totalSales;
  final double profit;
  final List<Purchase> purchases;
  final List<Sale> sales;

  Report({
    required this.startDate,
    required this.endDate,
    required this.totalPurchases,
    required this.totalSales,
    required this.profit,
    required this.purchases,
    required this.sales,
  });
}

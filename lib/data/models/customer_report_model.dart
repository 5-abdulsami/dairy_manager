// lib/modules/reports/customer_report_model.dart
import 'package:dairy_manager/data/models/customer_model.dart';
import 'package:dairy_manager/data/models/sale_model.dart';

class CustomerReport {
  final Customer customer;
  final DateTime startDate;
  final DateTime endDate;
  final List<Sale> sales;
  final double totalAmount;
  final int totalTransactions;

  CustomerReport({
    required this.customer,
    required this.startDate,
    required this.endDate,
    required this.sales,
    required this.totalAmount,
    required this.totalTransactions,
  });
}

// lib/data/repositories/sale_repository.dart
import 'package:get/get.dart';
import 'package:dairy_manager/core/database/database_helper.dart';
import 'package:dairy_manager/data/models/sale_model.dart';

class SaleRepository extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> addSale(Sale sale) async {
    final db = await _databaseHelper.database;
    return await db.insert('sales', sale.toMap());
  }

  Future<List<Sale>> getAllSales() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, c.name as customerName, c.shopName as shopName 
      FROM sales s 
      INNER JOIN customers c ON s.customerId = c.id
      ORDER BY s.date DESC
    ''');

    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customerName, c.shopName as shopName 
      FROM sales s 
      INNER JOIN customers c ON s.customerId = c.id
      WHERE s.date BETWEEN ? AND ?
      ORDER BY s.date DESC
    ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }

  Future<List<Sale>> getSalesByCustomer(
    int customerId,
    DateTime start,
    DateTime end,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, c.name as customerName, c.shopName as shopName 
      FROM sales s 
      INNER JOIN customers c ON s.customerId = c.id
      WHERE s.customerId = ? AND s.date BETWEEN ? AND ?
      ORDER BY s.date DESC
    ''',
      [customerId, start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }

  Future<double> getTotalSalesByDateRange(DateTime start, DateTime end) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) as total 
      FROM sales 
      WHERE date BETWEEN ? AND ?
    ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return maps[0]['total'] ?? 0.0;
  }

  Future<double> getTotalSalesByCustomer(
    int customerId,
    DateTime start,
    DateTime end,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) as total 
      FROM sales 
      WHERE customerId = ? AND date BETWEEN ? AND ?
    ''',
      [customerId, start.toIso8601String(), end.toIso8601String()],
    );

    return maps[0]['total'] ?? 0.0;
  }
}

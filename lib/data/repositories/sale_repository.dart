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
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
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
}

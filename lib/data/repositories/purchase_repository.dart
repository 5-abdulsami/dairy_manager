// lib/data/repositories/purchase_repository.dart
import 'package:get/get.dart';
import 'package:dairy_manager/core/database/database_helper.dart';
import 'package:dairy_manager/data/models/purchase_model.dart';

class PurchaseRepository extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> addPurchase(Purchase purchase) async {
    final db = await _databaseHelper.database;
    return await db.insert('purchases', purchase.toMap());
  }

  Future<List<Purchase>> getAllPurchases() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, s.name as supplierName 
      FROM purchases p 
      INNER JOIN suppliers s ON p.supplierId = s.id
      ORDER BY p.date DESC
    ''');

    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }

  Future<List<Purchase>> getPurchasesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT p.*, s.name as supplierName 
      FROM purchases p 
      INNER JOIN suppliers s ON p.supplierId = s.id
      WHERE p.date BETWEEN ? AND ?
      ORDER BY p.date DESC
    ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Purchase.fromMap(maps[i]);
    });
  }

  Future<double> getTotalPurchasesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) as total 
      FROM purchases 
      WHERE date BETWEEN ? AND ?
    ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return maps[0]['total'] ?? 0.0;
  }
}

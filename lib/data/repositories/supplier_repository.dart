// lib/data/repositories/supplier_repository.dart
import 'package:get/get.dart';
import 'package:dairy_manager/core/database/database_helper.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';

class SupplierRepository extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> addSupplier(Supplier supplier) async {
    final db = await _databaseHelper.database;
    return await db.insert('suppliers', supplier.toMap());
  }

  Future<List<Supplier>> getAllSuppliers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('suppliers');
    return List.generate(maps.length, (i) {
      return Supplier.fromMap(maps[i]);
    });
  }

  Future<List<Supplier>> getSuppliersByProduct(String productType) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'suppliers',
      where: 'productType = ?',
      whereArgs: [productType],
    );
    return List.generate(maps.length, (i) {
      return Supplier.fromMap(maps[i]);
    });
  }

  Future<int> updateSupplier(Supplier supplier) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'suppliers',
      supplier.toMap(),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  Future<int> deleteSupplier(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }
}

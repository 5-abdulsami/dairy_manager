// lib/data/repositories/customer_repository.dart
import 'package:get/get.dart';
import 'package:dairy_manager/core/database/database_helper.dart';
import 'package:dairy_manager/data/models/customer_model.dart';

class CustomerRepository extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> addCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    return await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}

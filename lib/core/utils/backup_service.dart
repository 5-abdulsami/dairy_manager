// lib/core/utils/backup_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dairy_manager/core/database/database_helper.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';

class BackupService {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();
  static final SupplierRepository _supplierRepo = Get.find();
  static final PurchaseRepository _purchaseRepo = Get.find();
  static final SaleRepository _saleRepo = Get.find();

  // Request storage permission
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // Export all data to a JSON file (let user choose location)
  // lib/core/utils/backup_service.dart - Update the exportData method
  static Future<File?> exportData() async {
    try {
      if (!await requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      // Get all data from database
      final suppliers = await _supplierRepo.getAllSuppliers();
      final purchases = await _purchaseRepo.getAllPurchases();
      final sales = await _saleRepo.getAllSales();

      // Convert to JSON
      final backupData = {
        'app_name': 'Mankiala Milk Shop',
        'backup_date': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'suppliers': suppliers.map((s) => s.toMap()).toList(),
        'purchases': purchases.map((p) => p.toMap()).toList(),
        'sales': sales.map((s) => s.toMap()).toList(),
      };

      // Convert to JSON string and then to bytes
      final jsonString = jsonEncode(backupData);
      final bytes = utf8.encode(jsonString);

      // Let user choose save location - FIXED: Provide bytes instead of path
      final String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName:
            'mankiala_milk_shop_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
        bytes: bytes, // Add this line to provide the file content
      );

      if (savePath == null) {
        // User cancelled the picker
        return null;
      }

      // Return the file reference (file_picker already saved it)
      return File(savePath);
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  // Import data from JSON file (let user choose file)
  static Future<void> importData() async {
    try {
      if (!await requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      // Let user choose file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        // User cancelled the picker
        return;
      }

      // Get the file
      final file = File(result.files.single.path!);

      // Read file
      final jsonString = await file.readAsString();
      final backupData = jsonDecode(jsonString);

      // Verify backup file
      if (backupData['app_name'] != 'Mankiala Milk Shop') {
        throw Exception(
          'Invalid backup file. This is not a Mankiala Milk Shop backup.',
        );
      }

      // Get database instance
      final db = await _databaseHelper.database;

      // Start transaction
      await db.transaction((txn) async {
        // Clear existing data
        await txn.delete('suppliers');
        await txn.delete('purchases');
        await txn.delete('sales');

        // Import suppliers - FIX NULL CHECK ERROR
        final suppliers = backupData['suppliers'] as List? ?? [];
        for (final supplierData in suppliers) {
          // Handle null values safely
          final mappedData = {
            'id': supplierData['id'],
            'name': supplierData['name'] ?? '',
            'phoneNumber': supplierData['phoneNumber'],
            'productType': supplierData['productType'] ?? '',
            'rate': (supplierData['rate'] as num?)?.toDouble() ?? 0.0,
            'createdAt':
                supplierData['createdAt'] ?? DateTime.now().toIso8601String(),
          };
          await txn.insert('suppliers', mappedData);
        }

        // Import purchases - FIX NULL CHECK ERROR
        final purchases = backupData['purchases'] as List? ?? [];
        for (final purchaseData in purchases) {
          // Handle null values safely
          final mappedData = {
            'id': purchaseData['id'],
            'supplierId': purchaseData['supplierId'] ?? 0,
            'supplierName': purchaseData['supplierName'] ?? '',
            'quantity': (purchaseData['quantity'] as num?)?.toDouble() ?? 0.0,
            'rate': (purchaseData['rate'] as num?)?.toDouble() ?? 0.0,
            'totalAmount':
                (purchaseData['totalAmount'] as num?)?.toDouble() ?? 0.0,
            'date': purchaseData['date'] ?? DateTime.now().toIso8601String(),
            'productType': purchaseData['productType'] ?? '',
            'unit': purchaseData['unit'] ?? '',
          };
          await txn.insert('purchases', mappedData);
        }

        // Import sales - FIX NULL CHECK ERROR
        final sales = backupData['sales'] as List? ?? [];
        for (final saleData in sales) {
          // Handle null values safely
          final mappedData = {
            'id': saleData['id'],
            'quantity': (saleData['quantity'] as num?)?.toDouble() ?? 0.0,
            'rate': (saleData['rate'] as num?)?.toDouble() ?? 0.0,
            'totalAmount': (saleData['totalAmount'] as num?)?.toDouble() ?? 0.0,
            'date': saleData['date'] ?? DateTime.now().toIso8601String(),
            'productType': saleData['productType'] ?? '',
            'unit': saleData['unit'] ?? '',
          };
          await txn.insert('sales', mappedData);
        }
      });
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  // Get backup files from downloads directory
  static Future<List<File>> getBackupFiles() async {
    try {
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) return [];

      final files = downloadsDir.listSync();
      return files
          .where(
            (file) =>
                file is File &&
                file.path.endsWith('.json') &&
                file.path.contains('mankiala_milk_shop_backup'),
          )
          .map((file) => file as File)
          .toList();
    } catch (e) {
      return [];
    }
  }
}

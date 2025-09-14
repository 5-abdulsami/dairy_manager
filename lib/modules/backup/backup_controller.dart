// lib/modules/backup/backup_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/core/services/backup_service.dart';

class BackupController extends GetxController {
  var isExporting = false.obs;
  var isImporting = false.obs;

  Future<void> exportBackup() async {
    isExporting.value = true;
    try {
      final backupFile = await BackupService.exportData();
      if (backupFile != null) {
        Get.snackbar(
          'Success',
          'Backup created successfully!\nSaved to: ${backupFile.path}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create backup: $e');
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> importBackup() async {
    isImporting.value = true;
    try {
      await BackupService.importData();
      Get.snackbar('Success', 'Data restored successfully!');
      // Refresh all data in the app
      await Future.delayed(Duration(seconds: 2));
      Get.offAllNamed('/');
    } catch (e) {
      Get.snackbar('Error', 'Failed to restore data: $e');
    } finally {
      isImporting.value = false;
    }
  }
}

// lib/modules/suppliers/suppliers_binding.dart
import 'package:dairy_manager/modules/backup/backup_controller.dart';
import 'package:get/get.dart';

class BackupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BackupController>(() => BackupController());
  }
}

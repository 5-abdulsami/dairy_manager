// lib/modules/reports/reports_binding.dart
import 'package:get/get.dart';
import 'package:dairy_manager/modules/reports/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsController>(() => ReportsController());
  }
}

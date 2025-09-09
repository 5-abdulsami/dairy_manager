// lib/modules/reports/reports_binding.dart
import 'package:get/get.dart';
import 'package:dairy_manager/modules/reports/supplier_report/supplier_report_controller.dart';

class SupplierReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierReportController>(() => SupplierReportController());
  }
}

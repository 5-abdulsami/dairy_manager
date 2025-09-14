// lib/modules/reports/reports_binding.dart
import 'package:dairy_manager/modules/reports/customer_report/customer_report_controller.dart';
import 'package:get/get.dart';

class CustomerReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerReportController>(() => CustomerReportController());
  }
}

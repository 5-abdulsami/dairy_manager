// lib/modules/sales/sales_binding.dart
import 'package:dairy_manager/modules/sales/add_sale_controller.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/modules/sales/sales_controller.dart';

class SalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesController>(() => SalesController());
    Get.lazyPut<AddSaleController>(() => AddSaleController());
  }
}

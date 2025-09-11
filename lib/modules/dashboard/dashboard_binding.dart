// lib/modules/suppliers/suppliers_binding.dart
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';
import 'package:dairy_manager/modules/dashboard/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut(() => SupplierRepository(), fenix: true);
    Get.lazyPut(() => PurchaseRepository(), fenix: true);
    Get.lazyPut(() => SaleRepository(), fenix: true);
  }
}

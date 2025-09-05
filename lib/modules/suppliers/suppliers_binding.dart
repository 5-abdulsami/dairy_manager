// lib/modules/suppliers/suppliers_binding.dart
import 'package:dairy_manager/modules/suppliers/add_supplier_controller.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/modules/suppliers/suppliers_controller.dart';

class SuppliersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuppliersController>(() => SuppliersController());
    Get.lazyPut<AddSupplierController>(() => AddSupplierController());
  }
}

// lib/modules/purchases/purchases_binding.dart
import 'package:dairy_manager/modules/purchases/add_purchase/add_purchases_controller.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/modules/purchases/purchases_controller.dart';

class PurchasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPurchaseController>(() => AddPurchaseController());
    Get.lazyPut<PurchasesController>(() => PurchasesController());
  }
}

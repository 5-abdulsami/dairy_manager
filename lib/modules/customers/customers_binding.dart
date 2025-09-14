// lib/modules/customers/customers_binding.dart
import 'package:get/get.dart';
import 'package:dairy_manager/modules/customers/customers_controller.dart';

class CustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomersController>(() => CustomersController());
  }
}

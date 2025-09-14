// lib/modules/customers/customers_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/customer_model.dart';
import 'package:dairy_manager/data/repositories/customer_repository.dart';

class CustomersController extends GetxController {
  final CustomerRepository customerRepository = Get.find();
  var customers = <Customer>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    loadCustomers();
    super.onInit();
  }

  Future<void> loadCustomers() async {
    isLoading.value = true;
    try {
      customers.value = await customerRepository.getAllCustomers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customers');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await customerRepository.deleteCustomer(id);
      customers.removeWhere((customer) => customer.id == id);
      Get.snackbar('Success', 'Customer deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete customer');
    }
  }
}

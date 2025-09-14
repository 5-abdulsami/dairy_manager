// lib/modules/customers/add_customer_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/customer_model.dart';
import 'package:dairy_manager/data/repositories/customer_repository.dart';

class AddCustomerController extends GetxController {
  final CustomerRepository customerRepository = Get.find();

  var name = ''.obs;
  var phoneNumber = ''.obs;
  var shopName = ''.obs;
  var address = ''.obs;
  var isLoading = false.obs;

  void setName(String value) => name.value = value;
  void setPhoneNumber(String value) => phoneNumber.value = value;
  void setShopName(String value) => shopName.value = value;
  void setAddress(String value) => address.value = value;

  Future<void> addCustomer() async {
    if (name.isEmpty || shopName.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final customer = Customer(
        name: name.value,
        phoneNumber: phoneNumber.value.isEmpty ? null : phoneNumber.value,
        shopName: shopName.value,
        address: address.value.isEmpty ? null : address.value,
        createdAt: DateTime.now(),
      );

      await customerRepository.addCustomer(customer);
      Get.back(result: true);
      Get.snackbar('Success', 'Customer added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add customer');
    } finally {
      isLoading.value = false;
    }
  }
}

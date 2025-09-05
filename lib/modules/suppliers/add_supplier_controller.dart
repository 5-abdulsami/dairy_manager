// lib/modules/suppliers/add_supplier_controller.dart
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';

class AddSupplierController extends GetxController {
  final SupplierRepository supplierRepository = Get.find();

  var name = ''.obs;
  var phoneNumber = ''.obs;
  var productType = AppConstants.milk.obs;
  var rate = 0.0.obs;
  var isLoading = false.obs;

  void setName(String value) => name.value = value;
  void setPhoneNumber(String value) => phoneNumber.value = value;
  void setProductType(String value) => productType.value = value;
  void setRate(String value) => rate.value = double.tryParse(value) ?? 0.0;

  Future<void> addSupplier() async {
    if (name.isEmpty || rate.value <= 0) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final supplier = Supplier(
        name: name.value,
        phoneNumber: phoneNumber.value.isEmpty ? null : phoneNumber.value,
        productType: productType.value,
        rate: rate.value,
        createdAt: DateTime.now(),
      );

      await supplierRepository.addSupplier(supplier);
      Get.back(result: true);
      Get.snackbar('Success', 'Supplier added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add supplier');
    } finally {
      isLoading.value = false;
    }
  }
}

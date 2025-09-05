// lib/modules/suppliers/suppliers_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';

class SuppliersController extends GetxController {
  final SupplierRepository supplierRepository = Get.find();
  var suppliers = <Supplier>[].obs;
  var isLoading = true.obs;
  var filteredSuppliers = <Supplier>[].obs;
  var filterProductType = 'All'.obs;

  @override
  void onInit() {
    loadSuppliers();
    super.onInit();
  }

  Future<void> loadSuppliers() async {
    isLoading.value = true;
    try {
      suppliers.value = await supplierRepository.getAllSuppliers();
      applyFilter();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load suppliers');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter() {
    if (filterProductType.value == 'All') {
      filteredSuppliers.value = suppliers;
    } else {
      filteredSuppliers.value =
          suppliers
              .where(
                (supplier) => supplier.productType == filterProductType.value,
              )
              .toList();
    }
  }

  Future<void> deleteSupplier(int id) async {
    try {
      await supplierRepository.deleteSupplier(id);
      suppliers.removeWhere((supplier) => supplier.id == id);
      applyFilter();
      Get.snackbar('Success', 'Supplier deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete supplier');
    }
  }

  void setFilter(String productType) {
    filterProductType.value = productType;
    applyFilter();
  }
}

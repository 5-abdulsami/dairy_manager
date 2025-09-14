// lib/modules/purchases/add_purchase_controller.dart
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';

class AddPurchaseController extends GetxController {
  final PurchaseRepository purchaseRepository = Get.find();
  final SupplierRepository supplierRepository = Get.find();

  var suppliers = <Supplier>[].obs;
  var selectedSupplier = Rxn<Supplier>();
  var quantity = 0.0.obs;
  var rate = 0.0.obs;
  var totalAmount = 0.0.obs;
  var date = DateTime.now().obs;
  var productType = AppConstants.milk.obs;
  var unit = AppConstants.kg.obs;
  var isLoading = false.obs;
  var isCalculating = false.obs;

  @override
  void onInit() {
    loadSuppliers();
    super.onInit();
  }

  Future<void> loadSuppliers() async {
    try {
      suppliers.value = await supplierRepository.getAllSuppliers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load suppliers');
    }
  }

  void setSelectedSupplier(Supplier? supplier) {
    selectedSupplier.value = supplier;
    if (supplier != null) {
      rate.value = supplier.rate;
      productType.value = supplier.productType;
      calculateTotal();
    }
  }

  void setQuantity(String value) {
    quantity.value = double.tryParse(value) ?? 0.0;
    calculateTotal();
  }

  void setRate(String value) {
    rate.value = double.tryParse(value) ?? 0.0;
    calculateTotal();
  }

  void setProductType(String value) {
    productType.value = value;
    calculateTotal();
  }

  void setUnit(String value) {
    unit.value = value;
    calculateTotal();
  }

  void setDate(DateTime newDate) {
    date.value = newDate;
  }

  void calculateTotal() {
    isCalculating.value = true;
    double calculatedQuantity = quantity.value;

    // Convert to kg for calculation if unit is mann
    if (unit.value == AppConstants.mann) {
      calculatedQuantity = quantity.value * AppConstants.mannToKg;
    }

    totalAmount.value = calculatedQuantity * rate.value;
    isCalculating.value = false;
  }

  Future<void> addPurchase() async {
    if (selectedSupplier.value == null ||
        quantity.value <= 0 ||
        rate.value <= 0) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final purchase = Purchase(
        supplierId: selectedSupplier.value!.id!,
        supplierName: selectedSupplier.value!.name,
        quantity: quantity.value,
        rate: rate.value,
        totalAmount: totalAmount.value,
        date: date.value,
        productType: productType.value,
        unit: unit.value,
      );

      await purchaseRepository.addPurchase(purchase);
      Get.back(result: true);
      Get.snackbar('Success', 'Purchase added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add purchase: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

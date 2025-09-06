// lib/modules/sales/add_sale_controller.dart
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/sale_model.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';

class AddSaleController extends GetxController {
  final SaleRepository saleRepository = Get.find();

  var quantity = 0.0.obs;
  var rate = 0.0.obs;
  var totalAmount = 0.0.obs;
  var date = DateTime.now().obs;
  var productType = AppConstants.milk.obs;
  var unit = AppConstants.kg.obs;
  var isLoading = false.obs;
  var isCalculating = false.obs;

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

  Future<void> addSale() async {
    if (quantity.value <= 0 || rate.value <= 0) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final sale = Sale(
        quantity: quantity.value,
        rate: rate.value,
        totalAmount: totalAmount.value,
        date: date.value,
        productType: productType.value,
        unit: unit.value,
      );

      await saleRepository.addSale(sale);
      Get.back(result: true);
      Get.snackbar('Success', 'Sale added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add sale');
    } finally {
      isLoading.value = false;
    }
  }
}

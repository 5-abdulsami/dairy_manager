// lib/modules/purchases/purchases_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';

class PurchasesController extends GetxController {
  final PurchaseRepository purchaseRepository = Get.find();
  var purchases = <Purchase>[].obs;
  var isLoading = true.obs;
  var filteredPurchases = <Purchase>[].obs;
  var filterStartDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var filterEndDate = DateTime.now().obs;

  @override
  void onInit() {
    loadPurchases();
    super.onInit();
  }

  Future<void> loadPurchases() async {
    isLoading.value = true;
    try {
      purchases.value = await purchaseRepository.getAllPurchases();
      applyDateFilter();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load purchases');
    } finally {
      isLoading.value = false;
    }
  }

  void applyDateFilter() {
    filteredPurchases.value =
        purchases
            .where(
              (purchase) =>
                  purchase.date.isAfter(
                    filterStartDate.value.subtract(Duration(days: 1)),
                  ) &&
                  purchase.date.isBefore(
                    filterEndDate.value.add(Duration(days: 1)),
                  ),
            )
            .toList();
  }

  void setDateFilter(DateTime start, DateTime end) {
    filterStartDate.value = start;
    filterEndDate.value = end;
    applyDateFilter();
  }

  double get totalFilteredAmount {
    return filteredPurchases.fold(
      0,
      (sum, purchase) => sum + purchase.totalAmount,
    );
  }
}

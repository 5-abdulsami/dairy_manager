// lib/modules/dashboard/dashboard_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';

class DashboardController extends GetxController {
  final PurchaseRepository purchaseRepository = Get.find();
  final SaleRepository saleRepository = Get.find();

  var totalPurchases = 0.0.obs;
  var totalSales = 0.0.obs;
  var profit = 0.0.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    loadDashboardData();
    super.onInit();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;

    try {
      // Get data for the current month
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      totalPurchases.value = await purchaseRepository
          .getTotalPurchasesByDateRange(firstDayOfMonth, lastDayOfMonth);

      totalSales.value = await saleRepository.getTotalSalesByDateRange(
        firstDayOfMonth,
        lastDayOfMonth,
      );

      profit.value = totalSales.value - totalPurchases.value;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}

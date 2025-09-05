// lib/modules/reports/reports_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';

class ReportsController extends GetxController {
  final PurchaseRepository purchaseRepository = Get.find();
  final SaleRepository saleRepository = Get.find();

  var isLoading = true.obs;
  var filterStartDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var filterEndDate = DateTime.now().obs;
  var totalPurchases = 0.0.obs;
  var totalSales = 0.0.obs;
  var profit = 0.0.obs;

  @override
  void onInit() {
    loadReportData();
    super.onInit();
  }

  Future<void> loadReportData() async {
    isLoading.value = true;
    try {
      totalPurchases.value = await purchaseRepository
          .getTotalPurchasesByDateRange(
            filterStartDate.value,
            filterEndDate.value,
          );

      totalSales.value = await saleRepository.getTotalSalesByDateRange(
        filterStartDate.value,
        filterEndDate.value,
      );

      profit.value = totalSales.value - totalPurchases.value;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load report data');
    } finally {
      isLoading.value = false;
    }
  }

  void setDateFilter(DateTime start, DateTime end) {
    filterStartDate.value = start;
    filterEndDate.value = end;
    loadReportData();
  }
}

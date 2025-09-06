// lib/modules/reports/reports_controller.dart
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/models/sale_model.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/report_model.dart';
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
  var purchases = <Purchase>[].obs;
  var sales = <Sale>[].obs;

  @override
  void onInit() {
    loadReportData();
    super.onInit();
  }

  Future<void> loadReportData() async {
    isLoading.value = true;
    try {
      // Get totals
      totalPurchases.value = await purchaseRepository
          .getTotalPurchasesByDateRange(
            filterStartDate.value,
            filterEndDate.value,
          );

      totalSales.value = await saleRepository.getTotalSalesByDateRange(
        filterStartDate.value,
        filterEndDate.value,
      );

      // Get detailed lists
      purchases.value = await purchaseRepository.getPurchasesByDateRange(
        filterStartDate.value,
        filterEndDate.value,
      );

      sales.value = await saleRepository.getSalesByDateRange(
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

  Report generateReport() {
    return Report(
      startDate: filterStartDate.value,
      endDate: filterEndDate.value,
      totalPurchases: totalPurchases.value,
      totalSales: totalSales.value,
      profit: profit.value,
      purchases: purchases.value,
      sales: sales.value,
    );
  }
}

// lib/modules/sales/sales_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/sale_model.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';

class SalesController extends GetxController {
  final SaleRepository saleRepository = Get.find();
  var sales = <Sale>[].obs;
  var isLoading = true.obs;
  var filteredSales = <Sale>[].obs;
  var filterStartDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var filterEndDate = DateTime.now().obs;

  @override
  void onInit() {
    loadSales();
    super.onInit();
  }

  Future<void> loadSales() async {
    isLoading.value = true;
    try {
      sales.value = await saleRepository.getAllSales();
      applyDateFilter();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sales');
    } finally {
      isLoading.value = false;
    }
  }

  void applyDateFilter() {
    filteredSales.value =
        sales
            .where(
              (sale) =>
                  sale.date.isAfter(
                    filterStartDate.value.subtract(Duration(days: 1)),
                  ) &&
                  sale.date.isBefore(
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
    return filteredSales.fold(0, (sum, sale) => sum + sale.totalAmount);
  }
}

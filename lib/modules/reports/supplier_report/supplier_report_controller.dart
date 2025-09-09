// lib/modules/reports/supplier_report_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';

class SupplierReportController extends GetxController {
  final PurchaseRepository purchaseRepository = Get.find();
  final SupplierRepository supplierRepository = Get.find();

  var suppliers = <Supplier>[].obs;
  var selectedSupplier = Rxn<Supplier>();
  var purchases = <Purchase>[].obs;
  var isLoading = true.obs;
  var filterStartDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var filterEndDate = DateTime.now().obs;
  var isGeneratingPdf = false.obs;

  @override
  void onInit() {
    loadSuppliers();
    super.onInit();
  }

  Future<void> loadSuppliers() async {
    isLoading.value = true;
    try {
      suppliers.value = await supplierRepository.getAllSuppliers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load suppliers');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedSupplier(Supplier? supplier) {
    selectedSupplier.value = supplier;
    if (supplier != null) {
      loadSupplierPurchases();
    }
  }

  Future<void> loadSupplierPurchases() async {
    if (selectedSupplier.value == null) return;

    isLoading.value = true;
    try {
      final allPurchases = await purchaseRepository.getPurchasesByDateRange(
        filterStartDate.value,
        filterEndDate.value,
      );

      // Filter purchases for the selected supplier
      purchases.value =
          allPurchases
              .where(
                (purchase) => purchase.supplierId == selectedSupplier.value!.id,
              )
              .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load purchases');
    } finally {
      isLoading.value = false;
    }
  }

  void setDateFilter(DateTime start, DateTime end) {
    filterStartDate.value = start;
    filterEndDate.value = end;
    if (selectedSupplier.value != null) {
      loadSupplierPurchases();
    }
  }

  double get totalAmount {
    return purchases.fold(0, (sum, purchase) => sum + purchase.totalAmount);
  }

  int get totalTransactions {
    return purchases.length;
  }
}

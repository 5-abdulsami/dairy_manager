// lib/modules/reports/customer_report_controller.dart
import 'package:get/get.dart';
import 'package:dairy_manager/data/models/sale_model.dart';
import 'package:dairy_manager/data/models/customer_model.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';
import 'package:dairy_manager/data/repositories/customer_repository.dart';

class CustomerReportController extends GetxController {
  final SaleRepository saleRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();

  var customers = <Customer>[].obs;
  var selectedCustomer = Rxn<Customer>();
  var sales = <Sale>[].obs;
  var isLoading = true.obs;
  var filterStartDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var filterEndDate = DateTime.now().obs;

  @override
  void onInit() {
    loadCustomers();
    super.onInit();
  }

  Future<void> loadCustomers() async {
    isLoading.value = true;
    try {
      customers.value = await customerRepository.getAllCustomers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customers');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedCustomer(Customer? customer) {
    selectedCustomer.value = customer;
    if (customer != null) {
      loadCustomerSales();
    }
  }

  Future<void> loadCustomerSales() async {
    if (selectedCustomer.value == null) return;

    isLoading.value = true;
    try {
      sales.value = await saleRepository.getSalesByCustomer(
        selectedCustomer.value!.id!,
        filterStartDate.value,
        filterEndDate.value,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sales');
    } finally {
      isLoading.value = false;
    }
  }

  void setDateFilter(DateTime start, DateTime end) {
    filterStartDate.value = start;
    filterEndDate.value = end;
    if (selectedCustomer.value != null) {
      loadCustomerSales();
    }
  }

  double get totalAmount {
    return sales.fold(0, (sum, sale) => sum + sale.totalAmount);
  }

  int get totalTransactions {
    return sales.length;
  }
}

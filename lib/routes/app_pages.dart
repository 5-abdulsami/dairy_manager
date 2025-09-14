// lib/routes/app_pages.dart
import 'package:dairy_manager/modules/activation/activation_view.dart';
import 'package:dairy_manager/modules/backup/backup_binding.dart';
import 'package:dairy_manager/modules/backup/backup_view.dart';
import 'package:dairy_manager/modules/dashboard/dashboard_binding.dart';
import 'package:dairy_manager/modules/dashboard/dashboard_view.dart';
import 'package:dairy_manager/modules/dev/developer_view.dart';
import 'package:dairy_manager/modules/purchases/add_purchase/add_purchases_view.dart';
import 'package:dairy_manager/modules/purchases/purchases_binding.dart';
import 'package:dairy_manager/modules/purchases/purchases_view.dart';
import 'package:dairy_manager/modules/reports/reports_binding.dart';
import 'package:dairy_manager/modules/reports/reports_view.dart';
import 'package:dairy_manager/modules/reports/supplier_report/supplier_report_binding.dart';
import 'package:dairy_manager/modules/reports/supplier_report/supplier_report_view.dart';
import 'package:dairy_manager/modules/sales/add_sale/add_sale_view.dart';
import 'package:dairy_manager/modules/sales/sales_binding.dart';
import 'package:dairy_manager/modules/sales/sales_view.dart';
import 'package:dairy_manager/modules/suppliers/add_supplier/add_supplier_view.dart';
import 'package:dairy_manager/modules/suppliers/suppliers_binding.dart';
import 'package:dairy_manager/modules/suppliers/suppliers_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/customers/add_customer/add_customer_view.dart';
import '../modules/customers/customers_binding.dart';
import '../modules/customers/customers_view.dart';
import '../modules/reports/customer_report/customer_report_binding.dart';
import '../modules/reports/customer_report/customer_report_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIERS,
      page: () => SuppliersView(),
      binding: SuppliersBinding(),
    ),
    GetPage(name: _Paths.ADD_SUPPLIER, page: () => AddSupplierView()),
    GetPage(
      name: _Paths.PURCHASES,
      page: () => PurchasesView(),
      binding: PurchasesBinding(),
    ),
    GetPage(name: _Paths.ADD_PURCHASE, page: () => AddPurchaseView()),
    GetPage(
      name: _Paths.SALES,
      page: () => SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SALE,
      page: () => AddSaleView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.REPORTS,
      page: () => ReportsView(),
      binding: ReportsBinding(),
    ),
    // In app_pages.dart
    GetPage(
      name: _Paths.BACKUP,
      page: () => BackupView(),
      binding: BackupBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_REPORT,
      page: () => SupplierReportView(),
      binding: SupplierReportBinding(),
    ),
    GetPage(name: _Paths.ACTIVATION, page: () => ActivationView()),
    GetPage(name: _Paths.DEVELOPER, page: () => DeveloperView()),
    GetPage(
      name: _Paths.CUSTOMERS,
      page: () => CustomersView(),
      binding: CustomersBinding(),
    ),
    GetPage(name: _Paths.ADD_CUSTOMER, page: () => AddCustomerView()),
    GetPage(
      name: _Paths.CUSTOMER_REPORT,
      page: () => CustomerReportView(),
      binding: CustomerReportBinding(),
    ),
  ];
}

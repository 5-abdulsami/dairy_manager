// lib/routes/app_pages.dart
import 'package:dairy_manager/modules/backup/backup_binding.dart';
import 'package:dairy_manager/modules/backup/backup_view.dart';
import 'package:dairy_manager/modules/dashboard/dashboard_binding.dart';
import 'package:dairy_manager/modules/dashboard/dashboard_view.dart';
import 'package:dairy_manager/modules/purchases/add_purchases_view.dart';
import 'package:dairy_manager/modules/purchases/purchases_binding.dart';
import 'package:dairy_manager/modules/purchases/purchases_view.dart';
import 'package:dairy_manager/modules/reports/reports_binding.dart';
import 'package:dairy_manager/modules/reports/reports_view.dart';
import 'package:dairy_manager/modules/sales/add_sale_view.dart';
import 'package:dairy_manager/modules/sales/sales_binding.dart';
import 'package:dairy_manager/modules/sales/sales_view.dart';
import 'package:dairy_manager/modules/suppliers/add_supplier_view.dart';
import 'package:dairy_manager/modules/suppliers/suppliers_binding.dart';
import 'package:dairy_manager/modules/suppliers/suppliers_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

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
  ];
}

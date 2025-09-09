// lib/routes/app_routes.dart
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const DASHBOARD = _Paths.DASHBOARD;
  static const SUPPLIERS = _Paths.SUPPLIERS;
  static const ADD_SUPPLIER = _Paths.ADD_SUPPLIER;
  static const PURCHASES = _Paths.PURCHASES;
  static const ADD_PURCHASE = _Paths.ADD_PURCHASE;
  static const SALES = _Paths.SALES;
  static const ADD_SALE = _Paths.ADD_SALE;
  static const REPORTS = _Paths.REPORTS;
  static const BACKUP = _Paths.BACKUP;
  static const SUPPLIER_REPORT = '/supplier-report';
}

abstract class _Paths {
  _Paths._();
  static const DASHBOARD = '/dashboard';
  static const SUPPLIERS = '/suppliers';
  static const ADD_SUPPLIER = '/add-supplier';
  static const PURCHASES = '/purchases';
  static const ADD_PURCHASE = '/add-purchase';
  static const SALES = '/sales';
  static const ADD_SALE = '/add-sale';
  static const REPORTS = '/reports';
  static const BACKUP = '/backup';
  static const SUPPLIER_REPORT = '/supplier-report';
}

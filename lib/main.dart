// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/theme/app_theme.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';

void main() {
  runApp(const MyApp());
}

double get screenWidth => Get.width;
double get screenHeight => Get.height;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dairy Shop Manager',
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => SupplierRepository(), fenix: true);
        Get.lazyPut(() => PurchaseRepository(), fenix: true);
        Get.lazyPut(() => SaleRepository(), fenix: true);
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}

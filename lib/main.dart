// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/theme/app_theme.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:dairy_manager/data/repositories/supplier_repository.dart';
import 'package:dairy_manager/data/repositories/purchase_repository.dart';
import 'package:dairy_manager/data/repositories/sale_repository.dart';
import 'package:dairy_manager/core/utils/activation_service.dart';

double get screenWidth => Get.width;
double get screenHeight => Get.height;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check activation status
  final isActivated = await ActivationService.isActivated();

  runApp(
    MyApp(initialRoute: isActivated ? Routes.DASHBOARD : Routes.ACTIVATION),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mankiala Milk Shop Manager',
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding:
          initialRoute == Routes.DASHBOARD
              ? BindingsBuilder(() {
                Get.lazyPut(() => SupplierRepository(), fenix: true);
                Get.lazyPut(() => PurchaseRepository(), fenix: true);
                Get.lazyPut(() => SaleRepository(), fenix: true);
              })
              : null,
      debugShowCheckedModeBanner: false,
    );
  }
}

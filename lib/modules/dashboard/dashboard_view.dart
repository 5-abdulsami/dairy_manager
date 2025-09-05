// lib/modules/dashboard/dashboard_view.dart
import 'package:dairy_manager/main.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/modules/dashboard/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Purchases',
                      '${AppConstants.currency}${controller.totalPurchases.value.toStringAsFixed(0)}',
                      Colors.red,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Sales',
                      '${AppConstants.currency}${controller.totalSales.value.toStringAsFixed(0)}',
                      Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildSummaryCard(
                'Profit',
                '${AppConstants.currency}${controller.profit.value.toStringAsFixed(0)}',
                controller.profit.value >= 0 ? Colors.blue : Colors.orange,
              ),
              SizedBox(height: screenHeight * 0.025), // 20 = 0.025
              // Quick Actions
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.01), // 8 = 0.01
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.3,
                  ),
                  children: [
                    _buildActionCard(
                      context,
                      'Add Purchase',
                      Icons.shopping_cart,
                      Colors.blue,
                      () => Get.toNamed(Routes.ADD_PURCHASE),
                    ),
                    _buildActionCard(
                      context,
                      'Add Sale',
                      Icons.point_of_sale,
                      Colors.green,
                      () => Get.toNamed(Routes.ADD_SALE),
                    ),
                    _buildActionCard(
                      context,
                      'Suppliers',
                      Icons.people,
                      Colors.orange,
                      () => Get.toNamed(Routes.SUPPLIERS),
                    ),
                    _buildActionCard(
                      context,
                      'Reports',
                      Icons.analytics,
                      Colors.purple,
                      () => Get.toNamed(Routes.REPORTS),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02), // 16 = 0.02
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              value,
              style: TextStyle(
                fontSize: screenHeight * 0.035, // 28 = 0.035
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.01), // 8 = 0.01
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: screenHeight * 0.06, color: color),
              SizedBox(height: screenHeight * 0.01), // 8 = 0.01
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

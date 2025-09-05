// lib/modules/purchases/purchases_view.dart
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:dairy_manager/modules/purchases/purchases_controller.dart';

class PurchasesView extends GetView<PurchasesController> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchases'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.ADD_PURCHASE),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(context),
          _buildSummaryCard(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: controller.filteredPurchases.length,
                itemBuilder: (context, index) {
                  final purchase = controller.filteredPurchases[index];
                  return _buildPurchaseCard(context, purchase);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(
                      dateFormat.format(controller.filterStartDate.value),
                    ),
                  ),
                ),
                Text(' to '),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(
                      dateFormat.format(controller.filterEndDate.value),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Obx(
      () => Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Purchases:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${AppConstants.currency}${controller.totalFilteredAmount.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseCard(BuildContext context, Purchase purchase) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          purchase.supplierName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${purchase.productType} - ${purchase.quantity} ${purchase.unit}',
            ),
            Text(
              'Rate: ${AppConstants.currency}${purchase.rate}/${purchase.unit == AppConstants.mann ? AppConstants.mann : AppConstants.kg}',
            ),
            Text('Date: ${dateFormat.format(purchase.date)}'),
          ],
        ),
        trailing: Text(
          '${AppConstants.currency}${purchase.totalAmount.toStringAsFixed(0)}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.filterStartDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.setDateFilter(picked, controller.filterEndDate.value);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.filterEndDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.setDateFilter(controller.filterStartDate.value, picked);
    }
  }
}

// lib/modules/sales/sales_view.dart
import 'package:dairy_manager/data/models/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:dairy_manager/modules/sales/sales_controller.dart';

class SalesView extends GetView<SalesController> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.ADD_SALE),
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
                itemCount: controller.filteredSales.length,
                itemBuilder: (context, index) {
                  final sale = controller.filteredSales[index];
                  return _buildSaleCard(context, sale);
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
        color: Colors.green[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Sales:',
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

  Widget _buildSaleCard(BuildContext context, Sale sale) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          sale.productType,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${sale.quantity} ${sale.unit}'),
            Text(
              'Rate: ${AppConstants.currency}${sale.rate}/${sale.unit == AppConstants.mann ? AppConstants.mann : AppConstants.kg}',
            ),
            Text('Date: ${dateFormat.format(sale.date)}'),
          ],
        ),
        trailing: Text(
          '${AppConstants.currency}${sale.totalAmount.toStringAsFixed(0)}',
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

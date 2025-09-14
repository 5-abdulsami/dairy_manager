// lib/modules/reports/customer_report_view.dart
import 'package:dairy_manager/data/models/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/core/services/pdf_service.dart';
import 'package:dairy_manager/modules/reports/customer_report/customer_report_controller.dart';

import '../../../data/models/customer_model.dart';
import '../../../data/models/customer_report_model.dart';
import '../../../main.dart';

// ignore: must_be_immutable
class CustomerReportView extends GetView<CustomerReportController> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var isGeneratingPdf = false.obs;

  CustomerReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Ledger Report'),
        actions: [
          Obx(
            () => IconButton(
              icon:
                  isGeneratingPdf.value
                      ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                      : Icon(Icons.picture_as_pdf),
              onPressed:
                  controller.selectedCustomer.value == null ||
                          controller.sales.isEmpty ||
                          isGeneratingPdf.value
                      ? null
                      : _generatePdfReport,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomerSelector(),
            SizedBox(height: 16),
            _buildDateFilterSection(context),
            SizedBox(height: 16),
            _buildSummarySection(),
            SizedBox(height: 16),
            Expanded(child: _buildSalesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Customer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Obx(
              () =>
                  controller.isLoading.value
                      ? CircularProgressIndicator()
                      : DropdownButtonFormField<Customer>(
                        value: controller.selectedCustomer.value,
                        items:
                            controller.customers.map((Customer customer) {
                              return DropdownMenuItem<Customer>(
                                value: customer,
                                child: Text(
                                  '${customer.name} (${customer.shopName})',
                                ),
                              );
                            }).toList(),
                        onChanged: controller.setSelectedCustomer,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Choose customer',
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Similar to SupplierReportView, copy the date filter, summary, and list methods)
  // Just replace "Supplier" with "Customer" in the text and logic
  Widget _buildDateFilterSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Period',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () => _selectStartDate(context),
                      child: Text(
                        dateFormat.format(controller.filterStartDate.value),
                      ),
                    ),
                  ),
                ),
                Text(' to '),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text(
                        dateFormat.format(controller.filterEndDate.value),
                      ),
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

  Widget _buildSummarySection() {
    return Obx(() {
      if (controller.selectedCustomer.value == null) {
        return SizedBox();
      }

      return Card(
        color: Colors.blue[50],
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Column(
            children: [
              Text(
                'Summary for ${controller.selectedCustomer.value!.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Transactions:'),
                  Text(controller.totalTransactions.toString()),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount:'),
                  Text(
                    '${AppConstants.currency}${controller.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSalesList() {
    return Obx(() {
      if (controller.selectedCustomer.value == null) {
        return Center(child: Text('Please select a supplier'));
      }

      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.sales.isEmpty) {
        return Center(child: Text('No purchases found for selected period'));
      }

      return ListView.builder(
        itemCount: controller.sales.length,
        itemBuilder: (context, index) {
          final purchase = controller.sales[index];
          return _buildSaleItem(purchase);
        },
      );
    });
  }

  Widget _buildSaleItem(Sale sale) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text('${sale.quantity} ${sale.unit} of ${sale.productType}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(sale.date)),
            Text(
              'Rate: ${AppConstants.currency}${sale.rate}/${sale.unit == AppConstants.mann ? AppConstants.mann : AppConstants.kg}',
            ),
          ],
        ),
        trailing: Text(
          '${AppConstants.currency}${sale.totalAmount.toStringAsFixed(0)}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _generatePdfReport() async {
    isGeneratingPdf.value = true;
    try {
      final supplier = controller.selectedCustomer.value!;
      final report = _createSupplierReport(supplier);
      final pdfFile = await PdfService.generateCustomerReportPdf(report);
      await PdfService.openFile(pdfFile);
      Get.snackbar('Success', 'PDF report generated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate PDF report: $e');
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  CustomerReport _createSupplierReport(Customer customer) {
    return CustomerReport(
      customer: customer,
      startDate: controller.filterStartDate.value,
      endDate: controller.filterEndDate.value,
      sales: controller.sales,
      totalAmount: controller.totalAmount,
      totalTransactions: controller.totalTransactions,
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

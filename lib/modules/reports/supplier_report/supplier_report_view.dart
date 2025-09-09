// lib/modules/reports/supplier_report_view.dart
import 'package:dairy_manager/data/models/purchase_model.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:dairy_manager/data/models/supplier_report_model.dart';
import 'package:dairy_manager/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/core/utils/pdf_service.dart';
import 'package:dairy_manager/modules/reports/supplier_report/supplier_report_controller.dart';

// ignore: must_be_immutable
class SupplierReportView extends GetView<SupplierReportController> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var isGeneratingPdf = false.obs;

  SupplierReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier Ledger Report'),
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
                  controller.selectedSupplier.value == null ||
                          controller.purchases.isEmpty ||
                          isGeneratingPdf.value
                      ? null
                      : _generatePdfReport,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.018),
        child: Column(
          children: [
            _buildSupplierSelector(),
            SizedBox(height: screenHeight * 0.018),
            _buildDateFilterSection(context),
            SizedBox(height: screenHeight * 0.018),
            _buildSummarySection(),
            SizedBox(height: screenHeight * 0.018),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Purchases',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: _buildPurchasesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Supplier',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Obx(
              () =>
                  controller.isLoading.value
                      ? CircularProgressIndicator()
                      : DropdownButtonFormField<Supplier>(
                        value: controller.selectedSupplier.value,
                        items:
                            controller.suppliers.map((Supplier supplier) {
                              return DropdownMenuItem<Supplier>(
                                value: supplier,
                                child: Text(
                                  '${supplier.name} (${supplier.productType})',
                                ),
                              );
                            }).toList(),
                        onChanged: controller.setSelectedSupplier,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Choose supplier',
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

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
      if (controller.selectedSupplier.value == null) {
        return SizedBox();
      }

      return Card(
        color: Colors.blue[50],
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Column(
            children: [
              Text(
                'Summary for ${controller.selectedSupplier.value!.name}',
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

  Widget _buildPurchasesList() {
    return Obx(() {
      if (controller.selectedSupplier.value == null) {
        return Center(child: Text('Please select a supplier'));
      }

      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.purchases.isEmpty) {
        return Center(child: Text('No purchases found for selected period'));
      }

      return ListView.builder(
        itemCount: controller.purchases.length,
        itemBuilder: (context, index) {
          final purchase = controller.purchases[index];
          return _buildPurchaseItem(purchase);
        },
      );
    });
  }

  Widget _buildPurchaseItem(Purchase purchase) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          '${purchase.quantity} ${purchase.unit} of ${purchase.productType}',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(purchase.date)),
            Text(
              'Rate: ${AppConstants.currency}${purchase.rate}/${purchase.unit == AppConstants.mann ? AppConstants.mann : AppConstants.kg}',
            ),
          ],
        ),
        trailing: Text(
          '${AppConstants.currency}${purchase.totalAmount.toStringAsFixed(0)}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _generatePdfReport() async {
    isGeneratingPdf.value = true;
    try {
      final supplier = controller.selectedSupplier.value!;
      final report = _createSupplierReport(supplier);
      final pdfFile = await PdfService.generateSupplierReportPdf(report);
      await PdfService.openFile(pdfFile);
      Get.snackbar('Success', 'PDF report generated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate PDF report: $e');
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  SupplierReport _createSupplierReport(Supplier supplier) {
    return SupplierReport(
      supplier: supplier,
      startDate: controller.filterStartDate.value,
      endDate: controller.filterEndDate.value,
      purchases: controller.purchases,
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

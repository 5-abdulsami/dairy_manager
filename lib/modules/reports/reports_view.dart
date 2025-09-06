// lib/modules/reports/reports_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/core/utils/pdf_service.dart';
import 'package:dairy_manager/modules/reports/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var isGeneratingPdf = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        actions: [
          Obx(
            () => IconButton(
              icon:
                  isGeneratingPdf.value
                      ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                      : Icon(Icons.download),
              onPressed: isGeneratingPdf.value ? null : _generatePdfReport,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            children: [
              _buildDateFilterSection(context),
              SizedBox(height: 16),
              _buildSummaryCard(
                'Total Purchases',
                '${AppConstants.currency}${controller.totalPurchases.value.toStringAsFixed(0)}',
                Colors.red,
              ),
              SizedBox(height: 16),
              _buildSummaryCard(
                'Total Sales',
                '${AppConstants.currency}${controller.totalSales.value.toStringAsFixed(0)}',
                Colors.green,
              ),
              SizedBox(height: 16),
              _buildSummaryCard(
                'Profit',
                '${AppConstants.currency}${controller.profit.value.toStringAsFixed(0)}',
                controller.profit.value >= 0 ? Colors.blue : Colors.orange,
              ),
              SizedBox(height: 24),
              _buildProfitIndicator(),
              SizedBox(height: 16),
              _buildStatisticsInfo(),
              SizedBox(height: 30), // Extra padding at bottom
            ],
          );
        }),
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

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitIndicator() {
    return Card(
      color:
          controller.profit.value >= 0 ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              controller.profit.value >= 0
                  ? Icons.trending_up
                  : Icons.trending_down,
              size: 48,
              color:
                  controller.profit.value >= 0 ? Colors.green : Colors.orange,
            ),
            SizedBox(height: 8),
            Text(
              controller.profit.value >= 0 ? 'Profit' : 'Loss',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    controller.profit.value >= 0 ? Colors.green : Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${AppConstants.currency}${controller.profit.value.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    controller.profit.value >= 0 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Transaction Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Purchases:'),
                Text('${controller.purchases.length} transactions'),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales:'),
                Text('${controller.sales.length} transactions'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdfReport() async {
    isGeneratingPdf.value = true;
    try {
      final report = controller.generateReport();
      final pdfFile = await PdfService.generateReportPdf(report);
      await PdfService.openFile(pdfFile);
      Get.snackbar('Success', 'PDF report generated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate PDF report: $e');
    } finally {
      isGeneratingPdf.value = false;
    }
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

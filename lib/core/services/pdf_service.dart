// lib/core/utils/pdf_service.dart
import 'dart:io';
import 'package:dairy_manager/data/models/supplier_report_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/data/models/report_model.dart';

import '../../data/models/customer_report_model.dart';

class PdfService {
  static Future<File> generateReportPdf(Report report) async {
    final pdf = pw.Document();

    // Add header
    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              _buildHeader(report),
              pw.SizedBox(height: 20),
              _buildSummarySection(report),
              pw.SizedBox(height: 20),
              _buildPurchasesSection(report),
              pw.SizedBox(height: 20),
              _buildSalesSection(report),
            ],
      ),
    );

    // Save the PDF
    return _saveDocument(
      pdf,
      'dairy_report_${DateFormat('yyyyMMdd').format(report.startDate)}_${DateFormat('yyyyMMdd').format(report.endDate)}.pdf',
    );
  }

  static pw.Widget _buildHeader(Report report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Mankiala Milk Shop Report',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Period: ${DateFormat('dd/MM/yyyy').format(report.startDate)} - ${DateFormat('dd/MM/yyyy').format(report.endDate)}',
          style: pw.TextStyle(fontSize: 14),
        ),
        pw.Text(
          'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
          style: pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  static pw.Widget _buildSummarySection(Report report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Purchases:'),
              pw.Text(
                '${AppConstants.currency}${report.totalPurchases.toStringAsFixed(0)}',
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Sales:'),
              pw.Text(
                '${AppConstants.currency}${report.totalSales.toStringAsFixed(0)}',
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Profit/Loss:'),
              pw.Text(
                '${AppConstants.currency}${report.profit.toStringAsFixed(0)}',
                style: pw.TextStyle(
                  color: report.profit >= 0 ? PdfColors.green : PdfColors.red,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPurchasesSection(Report report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Purchases (${report.purchases.length})',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          if (report.purchases.isEmpty) pw.Text('No purchases in this period'),
          if (report.purchases.isNotEmpty)
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Supplier',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Product',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Quanitity',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...report.purchases
                    .map(
                      (purchase) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              DateFormat('dd/MM/yy').format(purchase.date),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(purchase.supplierName),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(purchase.productType),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${purchase.quantity} ${purchase.unit}',
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${AppConstants.currency}${purchase.totalAmount.toStringAsFixed(0)}',
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildSalesSection(Report report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Sales (${report.sales.length})',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          if (report.sales.isEmpty) pw.Text('No sales in this period'),
          if (report.sales.isNotEmpty)
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Customer',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Product',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Quantity',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...report.sales
                    .map(
                      (sale) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              DateFormat('dd/MM/yy').format(sale.date),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(sale.customerName),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(sale.productType),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('${sale.quantity} ${sale.unit}'),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${AppConstants.currency}${sale.totalAmount.toStringAsFixed(0)}',
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
        ],
      ),
    );
  }

  static Future<File> _saveDocument(pw.Document document, String name) async {
    final bytes = await document.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<void> openFile(File file) async {
    await OpenFile.open(file.path);
  }

  // Supplier PDF Report
  static Future<File> generateSupplierReportPdf(SupplierReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              _buildSupplierReportHeader(report),
              pw.SizedBox(height: 20),
              _buildSupplierInfoSection(report),
              pw.SizedBox(height: 20),
              _buildSupplierSummarySection(report),
              pw.SizedBox(height: 20),
              _buildSupplierPurchasesSection(report),
            ],
      ),
    );

    return _saveDocument(
      pdf,
      '${report.supplier.name}_ledger_${DateFormat('yyyyMMdd').format(report.startDate)}_${DateFormat('yyyyMMdd').format(report.endDate)}.pdf',
    );
  }

  static pw.Widget _buildSupplierReportHeader(SupplierReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Mankiala Milk Shop - Supplier Ledger',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Supplier: ${report.supplier.name}',
          style: pw.TextStyle(fontSize: 18),
        ),
        pw.Text(
          'Period: ${DateFormat('dd/MM/yyyy').format(report.startDate)} - ${DateFormat('dd/MM/yyyy').format(report.endDate)}',
          style: pw.TextStyle(fontSize: 14),
        ),
        pw.Text(
          'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
          style: pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  static pw.Widget _buildSupplierInfoSection(SupplierReport report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Supplier Information',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Row(children: [pw.Text('Name:'), pw.Text(report.supplier.name)]),
          pw.Row(
            children: [
              pw.Text('Phone:'),
              pw.Text(report.supplier.phoneNumber ?? 'Not provided'),
            ],
          ),
          pw.Row(
            children: [
              pw.Text('Product Type:'),
              pw.Text(report.supplier.productType),
            ],
          ),
          pw.Row(
            children: [
              pw.Text('Rate:'),
              pw.Text('${AppConstants.currency}${report.supplier.rate}/kg'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSupplierSummarySection(SupplierReport report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Transactions:'),
              pw.Text(report.totalTransactions.toString()),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Amount:'),
              pw.Text(
                '${AppConstants.currency}${report.totalAmount.toStringAsFixed(2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSupplierPurchasesSection(SupplierReport report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Purchase Details (${report.purchases.length} transactions)',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          if (report.purchases.isEmpty) pw.Text('No purchases in this period'),
          if (report.purchases.isNotEmpty)
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Product',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Qty',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...report.purchases
                    .map(
                      (purchase) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              DateFormat('dd/MM/yy').format(purchase.date),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${purchase.productType} (${purchase.unit})',
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${purchase.quantity} ${purchase.unit}',
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${AppConstants.currency}${purchase.totalAmount.toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
        ],
      ),
    );
  }

  // Customer PDF Report
  static Future<File> generateCustomerReportPdf(CustomerReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              _buildCustomerReportHeader(report),
              pw.SizedBox(height: 20),
              _buildCustomerInfoSection(report),
              pw.SizedBox(height: 20),
              _buildCustomerSummarySection(report),
              pw.SizedBox(height: 20),
              _buildCustomerSalesSection(report),
            ],
      ),
    );

    return _saveDocument(
      pdf,
      '${report.customer.name}_ledger_${DateFormat('yyyyMMdd').format(report.startDate)}_${DateFormat('yyyyMMdd').format(report.endDate)}.pdf',
    );
  }

  static pw.Widget _buildCustomerReportHeader(CustomerReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Mankiala Milk Shop - Customer Ledger',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Customer: ${report.customer.name}',
          style: pw.TextStyle(fontSize: 18),
        ),
        pw.Text(
          'Shop: ${report.customer.shopName}',
          style: pw.TextStyle(fontSize: 16),
        ),
        pw.Text(
          'Period: ${DateFormat('dd/MM/yyyy').format(report.startDate)} - ${DateFormat('dd/MM/yyyy').format(report.endDate)}',
          style: pw.TextStyle(fontSize: 14),
        ),
        pw.Text(
          'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
          style: pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  static pw.Widget _buildCustomerInfoSection(CustomerReport report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Customer Information',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Row(children: [pw.Text('Name:'), pw.Text(report.customer.name)]),
          pw.Row(
            children: [pw.Text('Shop:'), pw.Text(report.customer.shopName)],
          ),
          pw.Row(
            children: [
              pw.Text('Phone:'),
              pw.Text(report.customer.phoneNumber ?? 'Not provided'),
            ],
          ),
          if (report.customer.address != null)
            pw.Row(
              children: [
                pw.Text('Address:'),
                pw.Text(report.customer.address!),
              ],
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomerSummarySection(CustomerReport report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Transactions:'),
              pw.Text(report.totalTransactions.toString()),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Amount:'),
              pw.Text(
                '${AppConstants.currency}${report.totalAmount.toStringAsFixed(0)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomerSalesSection(CustomerReport report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Sales Details (${report.sales.length} transactions)',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          if (report.sales.isEmpty) pw.Text('No sales in this period'),
          if (report.sales.isNotEmpty)
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Product',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Qty',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text(
                        'Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...report.sales
                    .map(
                      (sale) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              DateFormat('dd/MM/yy').format(sale.date),
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${sale.productType} (${sale.unit})',
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('${sale.quantity} ${sale.unit}'),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${AppConstants.currency}${sale.totalAmount.toStringAsFixed(0)}',
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
        ],
      ),
    );
  }
}

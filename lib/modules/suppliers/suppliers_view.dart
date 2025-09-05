// lib/modules/suppliers/suppliers_view.dart
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:dairy_manager/modules/suppliers/suppliers_controller.dart';

class SuppliersView extends GetView<SuppliersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.ADD_SUPPLIER),
          ),
          PopupMenuButton<String>(
            onSelected: controller.setFilter,
            itemBuilder: (BuildContext context) {
              return ['All', ...AppConstants.productTypes].map((String value) {
                return PopupMenuItem<String>(value: value, child: Text(value));
              }).toList();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Filter: ${controller.filterProductType.value}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = controller.filteredSuppliers[index];
                  return _buildSupplierCard(context, supplier);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSupplierCard(BuildContext context, Supplier supplier) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          supplier.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(supplier.phoneNumber ?? 'No phone number'),
            Text(
              '${supplier.productType} - ${AppConstants.currency}${supplier.rate}/kg',
            ),
            Text('Added: ${_formatDate(supplier.createdAt)}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteDialog(context, supplier),
        ),
        onTap: () => _showEditDialog(context, supplier),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(BuildContext context, Supplier supplier) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Supplier'),
        content: Text('Are you sure you want to delete ${supplier.name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteSupplier(supplier.id!);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Supplier supplier) {
    // Implementation for edit dialog
    Get.snackbar('Info', 'Edit functionality will be implemented soon');
  }
}

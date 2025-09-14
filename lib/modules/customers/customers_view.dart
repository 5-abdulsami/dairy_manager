// lib/modules/customers/customers_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/routes/app_pages.dart';
import 'package:dairy_manager/modules/customers/customers_controller.dart';

import '../../data/models/customer_model.dart';

class CustomersView extends GetView<CustomersController> {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.ADD_CUSTOMER),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.customers.length,
          itemBuilder: (context, index) {
            final customer = controller.customers[index];
            return _buildCustomerCard(context, customer);
          },
        );
      }),
    );
  }

  Widget _buildCustomerCard(BuildContext context, Customer customer) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          customer.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.shopName),
            Text(customer.phoneNumber ?? 'No phone number'),
            if (customer.address != null) Text(customer.address!),
            Text('Added: ${_formatDate(customer.createdAt)}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteDialog(context, customer),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(BuildContext context, Customer customer) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Customer'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteCustomer(customer.id!);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

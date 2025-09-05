// lib/modules/suppliers/add_supplier_view.dart
import 'package:dairy_manager/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';
import 'package:dairy_manager/modules/suppliers/add_supplier_controller.dart';

class AddSupplierView extends GetView<AddSupplierController> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Supplier')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Supplier Name *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter supplier name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: controller.setPhoneNumber,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Product Type *',
                    border: OutlineInputBorder(),
                  ),
                  value: controller.productType.value,
                  items:
                      AppConstants.productTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) => controller.setProductType(value!),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rate per kg (Rs.) *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: controller.setRate,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid rate';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? CircularProgressIndicator()
                          : CustomButton(
                            text: 'ADD SUPPLIER',
                            onPressed: () => controller.addSupplier(),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

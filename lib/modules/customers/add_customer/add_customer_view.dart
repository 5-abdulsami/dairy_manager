// lib/modules/customers/add_customer_view.dart
import 'package:dairy_manager/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/modules/customers/add_customer/add_customer_controller.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  final _formKey = GlobalKey<FormState>();
  @override
  final controller = Get.put(AddCustomerController());

  AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Customer Name *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Shop Name *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: controller.setShopName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop name';
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: controller.setAddress,
                ),
                SizedBox(height: 24),
                Obx(
                  () =>
                      controller.isLoading.value
                          ? CircularProgressIndicator()
                          : CustomButton(
                            text: 'Save',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.addCustomer();
                              }
                            },
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

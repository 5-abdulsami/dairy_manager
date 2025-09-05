// lib/modules/purchases/add_purchase_view.dart
import 'package:dairy_manager/core/widgets/custom_button.dart';
import 'package:dairy_manager/data/models/supplier_model.dart';
import 'package:dairy_manager/modules/purchases/add_purchases_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dairy_manager/core/constants/app_constants.dart';

class AddPurchaseView extends GetView<AddPurchaseController> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController rateController = TextEditingController();
  @override
  final controller = Get.put(AddPurchaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Purchase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Obx(
                () => DropdownButtonFormField<Supplier>(
                  decoration: InputDecoration(
                    labelText: 'Supplier *',
                    border: OutlineInputBorder(),
                  ),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a supplier';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: controller.setQuantity,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter valid quantity';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      value: controller.unit.value,
                      items:
                          [AppConstants.kg, AppConstants.mann].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) => controller.setUnit(value!),
                    ),
                  ),
                ],
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
              TextButton(
                onPressed: () => _selectDate(context),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Date: ${dateFormat.format(controller.date.value)}'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculation Summary',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Quantity: ${controller.quantity.value} ${controller.unit.value}',
                        ),
                        if (controller.unit.value == AppConstants.mann)
                          Text(
                            'Converted to kg: ${controller.quantity.value * AppConstants.mannToKg} kg',
                          ),
                        Text(
                          'Rate: ${AppConstants.currency}${controller.rate.value}/kg',
                        ),
                        Divider(),
                        Text(
                          'Total Amount: ${AppConstants.currency}${controller.totalAmount.value.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Obx(
                () =>
                    controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                          text: 'SAVE',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.addPurchase();
                            }
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.date.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.setDate(picked);
    }
  }
}

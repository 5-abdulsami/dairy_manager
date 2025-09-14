// lib/modules/dev/developer_view.dart (For your use only)
import 'package:dairy_manager/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/services/activation_service.dart';

class DeveloperView extends StatefulWidget {
  @override
  _DeveloperViewState createState() => _DeveloperViewState();
}

class _DeveloperViewState extends State<DeveloperView> {
  var _usedCodes = <String>[].obs;
  var _availableCodes = <String>[].obs;

  @override
  void initState() {
    super.initState();
    _loadCodes();
  }

  Future<void> _loadCodes() async {
    _usedCodes.value = await ActivationService.getUsedCodes();
    _availableCodes.value = await ActivationService.getAvailableCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Developer Tools')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Codes: ${_availableCodes.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: _availableCodes.length,
                  itemBuilder:
                      (context, index) => ListTile(
                        title: Text(_availableCodes[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.content_copy, size: 20),
                          onPressed: () => _copyCode(_availableCodes[index]),
                        ),
                      ),
                ),
              ),
            ),
            Divider(),
            Text(
              'Used Codes: ${_usedCodes.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: _usedCodes.length,
                  itemBuilder:
                      (context, index) => ListTile(
                        title: Text(_usedCodes[index]),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      ),
                ),
              ),
            ),
            CustomButton(
              text: 'Reset Activation (Testing)',
              onPressed: ActivationService.resetActivation,
            ),
          ],
        ),
      ),
    );
  }

  void _copyCode(String code) {
    // You can add clipboard functionality here
    Get.snackbar('Copied', 'Code: $code');
  }
}

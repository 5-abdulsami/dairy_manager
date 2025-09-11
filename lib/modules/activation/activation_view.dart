// lib/modules/activation/activation_view.dart
import 'package:dairy_manager/main.dart';
import 'package:dairy_manager/modules/dev/developer_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/core/utils/activation_service.dart';
import 'package:dairy_manager/routes/app_pages.dart';

class ActivationView extends StatefulWidget {
  @override
  _ActivationViewState createState() => _ActivationViewState();
}

class _ActivationViewState extends State<ActivationView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  var _isLoading = false;
  var _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.vpn_key, size: 64, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Activate App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter your 6-digit activation code to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Activation Code',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter activation code';
                        }
                        if (value.length != 6) {
                          return 'Code must be 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 16),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _activateApp,
                        child: Text('Activate App'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: _showHelp,
                    child: Text('Need an activation code? Contact developer'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onLongPress: () {
                      Get.to(() => DeveloperView());
                    },
                    child: Divider(
                      height: 10,
                      thickness: 6,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _activateApp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final result = await ActivationService.activateApp(
        _codeController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        setState(() {
          _errorMessage = result.message;
        });
      }
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Activation Help'),
            content: Text(
              'Please contact the app developer to get your activation code.\n\n'
              'Each code can only be used once. If you need a new code, please request it from the developer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}

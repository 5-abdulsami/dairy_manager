// lib/core/utils/activation_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class ActivationService {
  static const String _activatedKey = 'app_activated';
  static const String _usedCodesKey = 'used_codes';

  // Pre-defined list of 100 6-digit alphanumeric codes
  static const List<String> _activationCodes = [
    'A1B2C3',
    'D4E5F6',
    'G7H8I9',
    'J1K2L3',
    'M4N5O6',
    'P7Q8R9',
    'S1T2U3',
    'V4W5X6',
    'Y7Z8A9',
    'B1C2D3',
    'E4F5G6',
    'H7I8J9',
    'K1L2M3',
    'N4O5P6',
    'Q7R8S9',
    'T1U2V3',
    'W4X5Y6',
    'Z7A8B9',
    'C1D2E3',
    'F4G5H6',
    'I7J8K9',
    'L1M2N3',
    'O4P5Q6',
    'R7S8T9',
    'U1V2W3',
    'X4Y5Z6',
    'A7B8C9',
    'D1E2F3',
    'G4H5I6',
    'J7K8L9',
    'M1N2O3',
    'P4Q5R6',
    'S7T8U9',
    'V1W2X3',
    'Y4Z5A6',
    'B7C8D9',
    'E1F2G3',
    'H4I5J6',
    'K7L8M9',
    'N1O2P3',
    'Q4R5S6',
    'T7U8V9',
    'W1X2Y3',
    'Z4A5B6',
    'C7D8E9',
    'F1G2H3',
    'I4J5K6',
    'L7M8N9',
    'O1P2Q3',
    'R4S5T6',
    'U7V8W9',
    'X1Y2Z3',
    'A4B5C6',
    'D7E8F9',
    'G1H2I3',
    'J4K5L6',
    'M7N8O9',
    'P1Q2R3',
    'S4T5U6',
    'V7W8X9',
    'Y1Z2A3',
    'B4C5D6',
    'E7F8G9',
    'H1I2J3',
    'K4L5M6',
    'N7O8P9',
    'Q1R2S3',
    'T4U5V6',
    'W7X8Y9',
    'Z1A2B3',
    'C4D5E6',
    'F7G8H9',
    'I1J2K3',
    'L4M5N6',
    'O7P8Q9',
    'R1S2T3',
    'U4V5W6',
    'X7Y8Z9',
    'A1C2E3',
    'B4D5F6',
    'G7H9J1',
    'K2L4M6',
    'N8O0P2',
    'Q3R5S7',
    'T9U1V3',
    'W4X6Y8',
    'Z0A2B4',
    'C6D8E0',
    'F2G4H6',
    'I8J0K2',
    'L4M6N8',
    'O0P2Q4',
    'R6S8T0',
    'U2V4W6',
    'X8Y0Z2',
    'A4B6C8',
    'D0E2F4',
    'G6H8I0',
    'J2K4L6',
    'M8N0O2',
  ];

  // Check if app is activated
  static Future<bool> isActivated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_activatedKey) ?? false;
  }

  // Activate the app with code
  static Future<ActivationResult> activateApp(String enteredCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usedCodes = prefs.getStringList(_usedCodesKey) ?? [];

      // Clean the entered code (remove spaces, convert to uppercase)
      final cleanCode = enteredCode.trim().toUpperCase();

      // Check if code is valid
      if (!_activationCodes.contains(cleanCode)) {
        return ActivationResult(false, 'Invalid activation code');
      }

      // Check if code is already used
      if (usedCodes.contains(cleanCode)) {
        return ActivationResult(false, 'This code has already been used');
      }

      // Activate the app
      await prefs.setBool(_activatedKey, true);

      // Mark code as used
      usedCodes.add(cleanCode);
      await prefs.setStringList(_usedCodesKey, usedCodes);

      return ActivationResult(true, 'App activated successfully!');
    } catch (e) {
      return ActivationResult(false, 'Activation failed: $e');
    }
  }

  // Get all used codes (for your reference)
  static Future<List<String>> getUsedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usedCodesKey) ?? [];
  }

  // Get all available codes (for your reference)
  static Future<List<String>> getAvailableCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final usedCodes = prefs.getStringList(_usedCodesKey) ?? [];
    return _activationCodes.where((code) => !usedCodes.contains(code)).toList();
  }

  // Reset activation (for testing only)
  static Future<void> resetActivation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activatedKey);
  }
}

class ActivationResult {
  final bool success;
  final String message;

  ActivationResult(this.success, this.message);
}

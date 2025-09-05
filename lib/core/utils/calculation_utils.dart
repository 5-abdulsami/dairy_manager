// lib/core/utils/calculation_utils.dart
import 'package:dairy_manager/core/constants/app_constants.dart';

class CalculationUtils {
  static double calculateTotalAmount(
    double quantity,
    double rate,
    String unit,
  ) {
    double calculatedQuantity = quantity;

    if (unit == AppConstants.mann) {
      calculatedQuantity = quantity * AppConstants.mannToKg;
    }

    return calculatedQuantity * rate;
  }

  static double convertToKg(double quantity, String unit) {
    if (unit == AppConstants.mann) {
      return quantity * AppConstants.mannToKg;
    }
    return quantity;
  }

  static String formatCurrency(double amount) {
    return '${AppConstants.currency}${amount.toStringAsFixed(0)}';
  }
}

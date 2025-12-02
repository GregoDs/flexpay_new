import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// ---------------- Global Utility Class ----------------
class AppUtils {
  /// Format integer amounts with commas (financial standard)
  static String formatAmount(int amount) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(amount);
  }

  /// Optional: format double amounts with 2 decimals
  static String formatDecimal(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
}

/// ---------------- Text Formatter ----------------
class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Capitalize only the first letter, leave the rest as the user typed
    final text = newValue.text;
    final capitalized = text[0].toUpperCase() + text.substring(1);

    return newValue.copyWith(
      text: capitalized,
      selection: newValue.selection, 
    );
  }
}

String greetingMessage(String userName) {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return "Good morning, $userName 🌅";
  } else if (hour < 17) {
    return "Good afternoon, $userName ☀️";
  } else {
    return "Good evening, $userName 🌙";
  }
}

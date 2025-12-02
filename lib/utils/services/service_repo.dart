import 'package:flexpay/features/auth/repo/auth_repo.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // <-- import intl for number formatting

class StartupService {
  final AuthRepo _authRepo = AuthRepo();

  Future<String> decideNextRoute() async {
    // 1️⃣ First launch → onboarding
    final firstLaunch = await SharedPreferencesHelper.isFirstLaunch();
    if (firstLaunch) {
      return 'onboarding';
    }

    // 2️⃣ Load full UserModel (instead of token)
    final UserModel? user = await SharedPreferencesHelper.getUserModel();

    // No user or missing token → login
    if (user == null || user.token.isEmpty) {
      return 'login';
    }

    // 3️⃣ Validate token via API
    final isValid = await _validateToken(user.token);

    if (isValid) {
      return 'home';
    } else {
      // 4️⃣ If token invalid, clear everything → login
      await SharedPreferencesHelper.logout();
      return 'login';
    }
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await _authRepo.verifyToken(token);

      final success = response.data['success'] == true;
      final status = response.data['data']?['status']?.toString();

      return success && status == "Token is Valid";
    } catch (e) {
      print("❌ Token validation failed: $e");
      return false;
    }
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
      selection: newValue.selection, // keep cursor position
    );
  }
}

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
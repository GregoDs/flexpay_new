import 'dart:convert';
import 'dart:developer' as AppLogger;
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:flexpay/features/home/models/home_wallet_model/wallet_model.dart';
import 'package:flexpay/features/home/models/referral_model/referral_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  /// --- PHONE NUMBER VALIDATION --- ///
  String? _validatePhoneNumber(String phoneNumber) {
    // Remove any spaces or special characters
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check for valid formats: 07XXXXXXXX, 01XXXXXXXX, or 2547XXXXXXXX
    if (cleanPhone.length == 10) {
      if (cleanPhone.startsWith('07') || cleanPhone.startsWith('01')) {
        return null; // Valid format
      } else {
        return "Phone number must start with 07 or 01 for 10-digit format";
      }
    } else if (cleanPhone.length == 12 && cleanPhone.startsWith('254')) {
      final localPart = cleanPhone.substring(3);
      if (localPart.startsWith('7') || localPart.startsWith('1')) {
        return null; // Valid format
      } else {
        return "Phone number must be 2547XXXXXXXX or 2541XXXXXXXX format";
      }
    } else {
      return "Invalid phone number format. Use 07XXXXXXXX, 01XXXXXXXX, or 2547XXXXXXXX";
    }
  }

  /// --- EXTRACT USER-FRIENDLY ERROR MESSAGE --- ///
  String _extractErrorMessage(dynamic errorData) {
    try {
      AppLogger.log("🔍 Extracting error message from: $errorData");

      if (errorData is Map<String, dynamic>) {
        // Case 1: Direct message field in the error object
        if (errorData.containsKey('message') &&
            errorData['message'] is String &&
            errorData['message'].toString().trim().isNotEmpty) {
          final message = errorData['message'].toString().trim();
          AppLogger.log("📤 Found direct message: $message");
          // Don't show generic validation failed message
          if (message != "Validation failed") {
            return message;
          }
        }

        // Case 2: Nested validation errors (when errors is a Map)
        if (errorData.containsKey('errors') && errorData['errors'] is Map) {
          final validationErrors = errorData['errors'] as Map<String, dynamic>;

          // Look for specific phone validation errors
          if (validationErrors.containsKey('referral_phone') &&
              validationErrors['referral_phone'] is List &&
              (validationErrors['referral_phone'] as List).isNotEmpty) {
            return validationErrors['referral_phone'][0].toString();
          }

          // Look for any other validation error
          for (final value in validationErrors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
          }
        }

        // Case 3: When errors is a List of error objects
        if (errorData.containsKey('errors') && errorData['errors'] is List) {
          final errorsList = errorData['errors'] as List;

          for (final errorItem in errorsList) {
            if (errorItem is Map<String, dynamic>) {
              // Extract message from error object
              if (errorItem.containsKey('message') &&
                  errorItem['message'] is String &&
                  errorItem['message'].toString().trim().isNotEmpty) {
                final message = errorItem['message'].toString().trim();
                AppLogger.log("📤 Found message in error list: $message");
                return message;
              }
            } else if (errorItem is String && errorItem.trim().isNotEmpty) {
              // If error item is just a string
              AppLogger.log(
                "📤 Found string error in list: ${errorItem.trim()}",
              );
              return errorItem.trim();
            }
          }
        }
      } else if (errorData is String && errorData.trim().isNotEmpty) {
        AppLogger.log("📤 Found string message: ${errorData.trim()}");
        return errorData.trim();
      }
    } catch (e) {
      AppLogger.log("⚠️ Error parsing error message: $e");
    }

    return "An error occurred while processing your request";
  }

  /// --- GET USER'S WALLET --- ///
  Future<WalletResponse> getUserWallet() async {
    try {
      AppLogger.log("📥 Fetching user’s own wallet details...");

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in shared preferences");
      }

      final url = "${ApiService.prodEndpointWallet}/wallet/$userId";

      final response = await _apiService.get(url);

      // Parse backend response into WalletResponse model
      final walletResponse = WalletResponse.fromJson(response.data);

      if (walletResponse.errors != null && walletResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${walletResponse.errors}");
        throw Exception(walletResponse.errors!.first.toString());
      }

      // Pretty print JSON for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(walletResponse.toJson());
      AppLogger.log("📦 User Wallet Response:\n$prettyJson");

      return walletResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in getUserWallet: $message\n$stack");
      throw (message);
    }
  }

  /// --- GET LATEST TRANSACTIONS --- ///
  Future<LatestTransactionsResponse> getLatestTransactions() async {
    try {
      AppLogger.log("📥 Fetching user’s latest transactions...");

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in shared preferences");
      }

      final url =
          "${ApiService.prodEndpointBookingsTransactions}/transactions/latest/$userId";

      final response = await _apiService.get(url);

      // Parse backend response into LatestTransactionsResponse model
      final latestTransactionsResponse = LatestTransactionsResponse.fromJson(
        response.data,
      );

      if (latestTransactionsResponse.errors.isNotEmpty) {
        AppLogger.log(
          "⚠️ Backend errors: ${latestTransactionsResponse.errors}",
        );
        throw Exception(latestTransactionsResponse.errors.first.toString());
      }

      // Pretty print JSON for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(latestTransactionsResponse.toJson());
      AppLogger.log("📦 User Latest Transactions Response:\n$prettyJson");

      return latestTransactionsResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in getLatestTransactions: $message\n$stack");
      throw (message);
    }
  }

  /// --- MAKE REFERRAL --- ///
  Future<ReferralResponse> makeReferral(String phoneNumber) async {
    try {
      AppLogger.log("📤 Making referral for phone number: $phoneNumber");

      // Validate phone number format before making the request
      final validationError = _validatePhoneNumber(phoneNumber);
      if (validationError != null) {
        throw Exception(validationError);
      }

      final url = "${ApiService.prodEndpointChama}/refer";

      final body = {"phone_number": phoneNumber};

      final response = await _apiService.post(url, data: body);

      // Parse backend response into ReferralResponse
      final referralResponse = ReferralResponse.fromJson(response.data);

      // Handle backend errors if they exist
      if (referralResponse.errors != null &&
          referralResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${referralResponse.errors}");

        // Extract user-friendly error message by passing the entire response data
        final errorMessage = _extractErrorMessage(response.data);

        AppLogger.log("📤 Extracted error message: $errorMessage");
        throw Exception(errorMessage);
      }

      // Pretty print JSON for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(referralResponse.toJson());
      AppLogger.log("📦 Referral Response:\n$prettyJson");

      return referralResponse;
    } catch (e, stack) {
      // If the exception already contains our formatted message, use it directly
      if (e is Exception) {
        final exceptionStr = e.toString();
        if (exceptionStr.startsWith('Exception: ') &&
            !exceptionStr.contains('DioException')) {
          // Extract just the message part without "Exception: " prefix
          final message = exceptionStr.substring('Exception: '.length);
          AppLogger.log("❌ Referral error: $message");
          throw Exception(message);
        }
      }

      // Otherwise, use the generic error handler for network/system errors
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in makeReferral: $message\n$stack");
      throw Exception(message);
    }
  }
}

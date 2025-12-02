import 'dart:convert';
import 'dart:developer' as AppLogger;
import 'package:flexpay/features/payments/models/refunds_model/refunds_model.dart';
import 'package:flexpay/features/payments/models/top_up_wallet_model/topup_wallet_model.dart';
import 'package:flexpay/features/payments/models/voucher_model/voucher_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class PaymentsRepo {
  final ApiService _apiService;

  PaymentsRepo(this._apiService);

  /// ---Withdraw REQUEST WALLET REFUND --- ///
  Future<RefundResponse> requestWalletRefund({
    required double withAmount,
  }) async {
    try {
      AppLogger.log("📤 Initiating refund request...");

      final url = "${ApiService.prodEndpointWallet}/customer/refund/cash";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;
      final phoneNumber = userModel?.user.phoneNumber;
    // final phoneNumber = '254708075049';


    if (userId == null) {
      throw Exception("User phone number not found in storage.");
    }
    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw Exception("User phone number not found in storage.");
    }

      // Build request body
      final payload = {
        "phone_number": phoneNumber,
        "user_id": userId,
        "with_amount": withAmount,
      };

      AppLogger.log("📦 Refund Payload: $payload");

      final response = await _apiService.post(url, data: payload);

      // Parse the top-level response
      final refundResponse = RefundResponse.fromJson(response.data);

      // Handle nested case: sometimes "data" itself contains refundResponse-like structure
      if (refundResponse.data != null &&
          refundResponse.data is Map<String, dynamic> &&
          (refundResponse.data as Map<String, dynamic>).containsKey(
            "success",
          )) {
        final nested = NestedRefundResponse.fromJson(refundResponse.data);
        AppLogger.log("🔄 Parsed Nested Refund Response: ${nested.toJson()}");

        // Flatten nested into top-level RefundResponse for simplicity
        return RefundResponse(
          data: nested.data,
          errors: nested.errors,
          success: nested.success,
          statusCode: nested.statusCode,
        );
      }

      // Pretty print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(refundResponse.toJson());
      AppLogger.log("✅ Refund Response:\n$prettyJson");

      return refundResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in requestWalletRefund: $message\n$stack");
      throw (message);
    }
  }







//TOP UP WALLET VIA MPESA
Future<TopUpWalletHomeResponse> topUpWalletViaMpesa(
    double amount,
    String phoneNumber,
  ) async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      final walletPhoneNum = userModel?.user.phoneNumber;

      if (walletPhoneNum == null) {
        throw Exception("Wallet Phone Number cannot be empty");
      }

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final url = "${ApiService.prodEndpointPayments}/stk_request";

      final body = {
        "user_id": userId,
        "reference": walletPhoneNum,
        "amount": amount,
        "phone": phoneNumber,
        "description": "Wallet Top up",
        };

      // ✅ Make the POST request with the body
      final response = await _apiService.post(
        url,
        requiresAuth: true,
        data: body,
      );

      // ✅ Parse response into model
      final topUpWalletHomeResponse = TopUpWalletHomeResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      AppLogger.log(
        "📦 Mpesa payment response: ${topUpWalletHomeResponse.toJson()}",
      );

      // ✅ Return parsed response
      return topUpWalletHomeResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in making mpesa payment: $message");
      throw (message);
    }
  }
  



    // ------------------- VOUCHER ------------------- //
  Future<VoucherResponse> generateVoucher({
    required int merchantId,
    required String voucherAmount,
  }) async {
    try {
      AppLogger.log("📤 Generating Voucher...");

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;
     
      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }
     
      final url = "${ApiService.prodEndpointChama}/generate-voucher";

      final payload = {
        "merchant_id": merchantId,
        "user_id": userId.toString(),
        "amount": voucherAmount,
       
      };

      AppLogger.log("📦 Voucher Payload: $payload");

      final response = await _apiService.post(
        url,
        requiresAuth: true,
        data: payload,
      );

      final voucherResponse =
          VoucherResponse.fromJson(response.data as Map<String, dynamic>);

      if (voucherResponse.errors != null &&
          voucherResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${voucherResponse.errors}");
        throw Exception(voucherResponse.errors!.first.toString());
      }

      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(voucherResponse.toJson());
      AppLogger.log("✅ Voucher Response:\n$prettyJson");

      return voucherResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in generateVoucher: $message\n$stack");
      throw (message);
    }
  }
}  


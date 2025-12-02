import 'dart:convert';
import 'package:flexpay/features/flexchama/models/loan_request_model/loan_request_model.dart';
import 'package:flexpay/features/flexchama/models/pay_loan_model/pay_loan_model.dart';
import 'package:flexpay/features/flexchama/models/products_model/chama_products_model.dart';
import 'package:flexpay/features/flexchama/models/profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/registration_model/chama_reg_model.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';
import 'package:flexpay/features/flexchama/models/subscribe_chama_model/subscribe_chama_model.dart';
import 'package:flexpay/features/flexchama/models/withdraw_chama_savings/withdraw_savings_model.dart';
import 'package:flexpay/features/home/models/referral_model/referral_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

class ChamaRepo {
  final ApiService _apiService = ApiService();

  /// ---FETCH CHAMA USER PROFILE ---///
  Future<ChamaProfile?> fetchChamaUserProfile() async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;

      //when fetching details for a new member
      // final phoneNumber = "254706622071"

      if (phoneNumber == null || phoneNumber.isEmpty) {
        throw Exception("User phone number not found in storage.");
      }

      AppLogger.log("📞 Fetching Chama profile for phone: $phoneNumber");

      final url = "${ApiService.prodEndpointChama}/get-user/$phoneNumber";
      final response = await _apiService.get(url);

      // ✅ 3. Parse into response model
      final chamaProfileResponse = ChamaProfileResponse.fromJson(response.data);

      // ✅ 4. Check for errors
      if (chamaProfileResponse.errors != null &&
          chamaProfileResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${chamaProfileResponse.errors}");
        throw Exception(
          chamaProfileResponse.firstError ??
              "Unknown error fetching Chama profile",
        );
      }

      // ✅ 5. Check if profile exists
      final chamaProfile = chamaProfileResponse.profile;

      if (chamaProfile == null) {
        AppLogger.log("❌ No valid Chama profile found.");
        return null;
      }

      // ✅ Pretty-print profile JSON for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(chamaProfile.toJson());
      AppLogger.log("📦 Parsed Chama Profile:\n$prettyJson");

      return chamaProfile;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchChamaUserProfile: $message");
      throw (message);
    }
  }




  ///--- REGISTER NEW CHAMA MEMBER ---///
  Future<ChamaRegistrationResponse> registerChamaUser({
    required String firstName,
    required String lastName,
    required String idNumber,
    required String phoneNumber,
    String? dob,
    required String gender, // "Male" or "Female"
  }) async {
    try {
      AppLogger.log("📤 Registering Chama user: $firstName $lastName");

      final url = "${ApiService.prodEndpointChama}/join";

      // Prepare request body
      final body = {
        "first_name": firstName,
        "last_name": lastName,
        "id_number": idNumber,
        "phone_number": phoneNumber,
        // "phone_number": "0706622077",
        "dob": dob ?? "",
        "gender": gender.toLowerCase() == "male" ? 1 : 2,
      };

      final response = await _apiService.post(url, data: body);

      // Parse response
      final registrationResponse = ChamaRegistrationResponse.fromJson(
        response.data,
      );

      // Check for errors and extract specific error messages
      if (registrationResponse.errors.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${registrationResponse.errors}");
        
        // Extract the first error message without "Exception:" wrapper
        String errorMessage = registrationResponse.errors.first.toString();
        
        // If it's a validation error with field-specific messages, extract the actual message
        if (response.data != null && response.data['data'] != null && response.data['data']['errors'] != null) {
          final fieldErrors = response.data['data']['errors'] as Map<String, dynamic>;
          if (fieldErrors.isNotEmpty) {
            // Get the first field error message
            final firstFieldKey = fieldErrors.keys.first;
            final firstFieldErrors = fieldErrors[firstFieldKey] as List<dynamic>;
            if (firstFieldErrors.isNotEmpty) {
              errorMessage = firstFieldErrors.first.toString();
            }
          }
        }
        
        throw Exception(errorMessage);
      }

      // Pretty-print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(registrationResponse.toJson());
      AppLogger.log("📦 Registration Response:\n$prettyJson");

      return registrationResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in registerChamaUser: $message");
      throw (message);
    }
  }





  ///---FETCH CHAMA SAVINGS---///
  Future<ChamaSavingsResponse> fetchUserChamaSavings() async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;

      //when testing fetch details for a new member using this
      // final phoneNumber = '254708075049';

      if (phoneNumber == null || phoneNumber.isEmpty) {
        AppLogger.log("User phone number not found.");
      }
      AppLogger.log("📞 Fetching User Chama savings for phone: $phoneNumber");

      final url = "${ApiService.prodEndpointChama}/user-savings/$phoneNumber";
      final response = await _apiService.get(url);

      // ✅ Parse into response model
      final chamaSavingsResponse = ChamaSavingsResponse.fromJson(response.data);

      // 400: No member product → safe default
      final isEmptyResponse =
          chamaSavingsResponse.statusCode == 400 ||
          chamaSavingsResponse.data?.chamaDetails == null;

      if (isEmptyResponse) {
        AppLogger.log("ℹ️ No valid savings found. Returning empty defaults.");
        return ChamaSavingsResponse.empty(
          errorMessage: chamaSavingsResponse.errors?.first,
          statusCode: chamaSavingsResponse.statusCode,
          isCriticalError: false, // normal safe empty
        );
      }

      // Non-400 failure
      if (chamaSavingsResponse.success == false) {
        AppLogger.log(
          "⚠️ Non-400 error: ${chamaSavingsResponse.errors?.first}",
        );
        return ChamaSavingsResponse.empty(
          errorMessage: chamaSavingsResponse.errors?.first ?? "Unknown error",
          statusCode: chamaSavingsResponse.statusCode,
          isCriticalError: true, // mark as critical → UI shows "_"
        );
      }

      // ✅ Extract ChamaDetails for easier usage
      final chamaDetails = chamaSavingsResponse.data?.chamaDetails;
      if (chamaDetails == null) {
        AppLogger.log("❌ No valid Chama savings found.");
      }
      // ✅ Pretty-print ChamaDetails JSON for debugging
      final prettyJson = chamaSavingsResponse.data?.chamaDetails != null
          ? const JsonEncoder.withIndent(
              '  ',
            ).convert(chamaSavingsResponse.data!.chamaDetails.toJson())
          : null;
      if (prettyJson != null) {
        AppLogger.log("📦 Parsed Chama Savings:\n$prettyJson");
      }

      //if its a normal case return full response
      return chamaSavingsResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchUserChamaSavings: $message");
      return ChamaSavingsResponse.empty(
        errorMessage: message,
        isCriticalError: true, // network/unknown → show "_"
      );
    }
  }

  /// ---GET CHAMA PRODUCT ---///
  Future<ChamaProductsResponse> getAllChamaProducts({
    required String type,
  }) async {
    try {
      AppLogger.log("📥 Fetching all chama products for type: $type");

      final url = "${ApiService.prodEndpointChama}/products";

      final body = {"type": type};
      final response = await _apiService.post(url, data: body);

      final allChamasResponse = ChamaProductsResponse.fromJson(response.data);

      if (allChamasResponse.errors.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${allChamasResponse.errors}");
        throw Exception(allChamasResponse.errors.first.toString());
      }

      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(allChamasResponse.toJson());
      AppLogger.log("📦 All Chamas Response:\n$prettyJson");

      return allChamasResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in getAllChamaProducts: $message");
      throw (message);
    }
  }

  /// ---GET USER'S CHAMAS ---///
  Future<UserChamasResponse> getUserChamas() async {
    try {
      AppLogger.log("📥 Fetching user’s own chamas...");
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;
      // final phoneNumber = "254708075049";

      final url = "${ApiService.prodEndpointChama}/user-chamas/$phoneNumber";
      final response = await _apiService.get(url);

      final userChamasResponse = UserChamasResponse.fromJson(response.data);

      if (userChamasResponse.errors.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${userChamasResponse.errors}");
        throw Exception(userChamasResponse.errors.first.toString());
      }

      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(userChamasResponse.toJson());
      AppLogger.log("📦 User Chamas Response:\n$prettyJson");

      return userChamasResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in getUserChamas: $message");
      throw (message);
    }
  }




  ///--- SUBSCRIBE TO A CHAMA ---///
  Future<SubscribeChamaResponse> subscribeChama({
    required int productId,
    required double depositAmount,
  }) async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;
      // final phoneNumber = '254708075049';

      if (phoneNumber == null || phoneNumber.isEmpty) {
        throw Exception("User phone number not found in storage.");
      }

      final url = "${ApiService.prodEndpointChama}/subscribe";

      final body = {
        "phone_number": phoneNumber,
        "product_id": productId,
        "deposit_amount": depositAmount,
      };

      AppLogger.log(
        "📤 Subscribing user $phoneNumber to product $productId "
        "with deposit $depositAmount",
      );

      // ✅ 4. Send request
      final response = await _apiService.post(url, data: body);

      // ✅ 5. Parse into model
      final subscribeResponse = SubscribeChamaResponse.fromJson(response.data);

      // ✅ 6. Handle backend errors
      if (subscribeResponse.errors != null &&
          subscribeResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${subscribeResponse.errors}");
        throw Exception(subscribeResponse.errors!.first.toString());
      }

      // ✅ 7. Pretty-print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(subscribeResponse.toJson());
      AppLogger.log("📦 Subscribe Chama Response:\n$prettyJson");

      return subscribeResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in subscribeChama: $message");
      throw (message);
    }
  }

  
  ///--- Pay for CHAMA selected using Mpesa  ---///
Future<SubscribeChamaResponse> saveToChama({
  required int productId,
  required double amount,
}) async {
  try {
    final userModel = await SharedPreferencesHelper.getUserModel();
    final phoneNumber = userModel?.user.phoneNumber;
    // final phoneNumber = '254708075049';

    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw Exception("User phone number not found in storage.");
    }

    final url = "${ApiService.prodEndpointChama}/save";

    final body = {
      "phone_number": phoneNumber,
      "product_id": productId,
      "amount": amount,
    };

    AppLogger.log(
      "📤 Paying for chama user $phoneNumber to product $productId "
      "with deposit $amount",
    );

    // ✅ Send request
    final response = await _apiService.post(url, data: body);

    // ✅ Parse response safely
    final subscribeResponse = SubscribeChamaResponse.fromJson(response.data);

    // ✅ If backend returned errors, bubble them up
    if (subscribeResponse.errors != null &&
        subscribeResponse.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${subscribeResponse.errors}");
      throw Exception(subscribeResponse.errors!.first.toString());
    }

    // ✅ Handle case where response only contains messages (not full data)
    if (subscribeResponse.data == null &&
        (subscribeResponse.messages != null &&
            subscribeResponse.messages!.isNotEmpty)) {
      AppLogger.log(
        "ℹ️ Chama subscription message: ${subscribeResponse.messages!.join(", ")}",
      );
      return subscribeResponse;
    }

    // ✅ Pretty-print for debugging
    final prettyJson = const JsonEncoder.withIndent('  ')
        .convert(subscribeResponse.toJson());
    AppLogger.log("📦 Subscribe Chama Response:\n$prettyJson");

    return subscribeResponse;
  } catch (e) {
    final message = ErrorHandler.handleGenericError(e);
    AppLogger.log("❌ Error in subscribeChama: $message");
    throw (message);
  }
}







 /// ----------------------
/// Pay for CHAMA via Wallet
/// ----------------------
Future<SaveChamaWalletResponse> payChamaViaWallet({
  required int productId,
  required double amount,
}) async {
  try {
    final userModel = await SharedPreferencesHelper.getUserModel();
    final phoneNumber = userModel?.user.phoneNumber;
    // final phoneNumber = '254708075049'; // for testing

    final url = "${ApiService.prodEndpointChama}/wallet-transfer";

    final body = {
      "product_id": productId,
      "amount": amount,
    };

    AppLogger.log(
      "📤 Paying for chama user $phoneNumber to product $productId "
      "with deposit $amount",
    );

    // ✅ Send request
    final response = await _apiService.post(url, data: body);

    // ✅ Parse response safely
    final payChamaResponseWallet =
        SaveChamaWalletResponse.fromJson(response.data);

    // ✅ If backend returned errors, bubble them up
    if (payChamaResponseWallet.errors != null &&
        payChamaResponseWallet.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${payChamaResponseWallet.errors}");
      throw Exception(payChamaResponseWallet.errors!.first.toString());
    }

    // ✅ Pretty-print for debugging
    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(payChamaResponseWallet.toJson());
    AppLogger.log("📦 SaveChamaWalletResponse:\n$prettyJson");

    return payChamaResponseWallet;
  } catch (e) {
    final message = ErrorHandler.handleGenericError(e);
    AppLogger.log("❌ Error in payChamaViaWallet: $message");
    throw (message);
  }
}

 /// --- MAKE REFERRAL --- ///
  Future<ReferralResponse> makeReferral(String phoneNumber) async {
    try {
      AppLogger.log("📤 Making referral for phone number: $phoneNumber");

      final url = "${ApiService.prodEndpointChama}/refer";

      final body = {
        "phone_number": phoneNumber,
      };

      final response = await _apiService.post(url, data: body);

      // Parse backend response into ReferralResponse
      final referralResponse = ReferralResponse.fromJson(response.data);

      // Handle backend errors if they exist
      if (referralResponse.errors != null && referralResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${referralResponse.errors}");
        throw Exception(referralResponse.errors!.first.toString());
      }

      // Pretty print JSON for debugging
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(referralResponse.toJson());
      AppLogger.log("📦 Referral Response:\n$prettyJson");

      return referralResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in makeReferral: $message\n$stack");
      throw (message);
    }
  }






    /// --- WITHDRAW CHAMA SAVINGS --- ///
  Future<WithdrawChamaSavingsResponse> withdrawChamaSavings({
    required double amount,
  }) async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;
      // final phoneNumber = '254708075049'; // use this for testing if needed

      if (phoneNumber == null || phoneNumber.isEmpty) {
        throw Exception("User phone number not found in storage.");
      }

      final url = "${ApiService.prodEndpointChama}/withdraw";

      final body = {
        "phone_number": phoneNumber,
        "amount": amount,
      };

      AppLogger.log(
        "📤 Sending Chama withdrawal request for $phoneNumber "
        "amount: $amount",
      );

      // ✅ Send request
      final response = await _apiService.post(url, data: body);

      // ✅ Parse response safely into model
      final withdrawResponse =
          WithdrawChamaSavingsResponse.fromJson(response.data);

      // ✅ Log success/failure message
      AppLogger.log("📦 Raw Withdraw Response: ${response.data}");
      AppLogger.log("✅ Parsed Message: ${withdrawResponse.message}");

      // ✅ Handle backend errors
      if (withdrawResponse.success == false) {
        final errorMsg = withdrawResponse.message ?? "Withdrawal failed";
        AppLogger.log("⚠️ Backend error: $errorMsg");
        throw Exception(errorMsg);
      }

      // ✅ Pretty-print for debugging
      final prettyJson = const JsonEncoder.withIndent('  ')
          .convert(withdrawResponse.toJson());
      AppLogger.log("📦 WithdrawChamaSavingsResponse:\n$prettyJson");

      return withdrawResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in withdrawChamaSavings: $message");
      throw (message);
    }
  }
  


  
  
  
  /// --- REQUEST CHAMA LOAN --- ///
Future<ChamaLoanRequestResponse> borrowChamaLoan({
  required double amount,
}) async {
  try {
    // 1️⃣ Get current user info
    final userModel = await SharedPreferencesHelper.getUserModel();
    final phoneNumber = userModel?.user.phoneNumber;
    // final phoneNumber = '254708075049'; // Uncomment for local testing

    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw Exception("User phone number not found in storage.");
    }

    // 2️⃣ Build endpoint and payload
    final url = "${ApiService.prodEndpointChama}/borrow";
    final body = {
      "phone_number": phoneNumber,
      "amount": amount,
    };

    AppLogger.log(
      "📤 Sending Chama loan request for $phoneNumber "
      "amount: $amount",
    );

    // 3️⃣ Send request to backend
    final response = await _apiService.post(url, data: body);

    // 4️⃣ Parse response into strongly typed model
    final loanResponse = ChamaLoanRequestResponse.fromJson(response.data);

    // 5️⃣ Log useful details
    AppLogger.log("📦 Raw Loan Response: ${response.data}");
    AppLogger.log("✅ Parsed Message: ${loanResponse.message}");

    // 6️⃣ Handle backend errors
    if (loanResponse.success == false) {
      final errorMsg =
          loanResponse.errorMessages?.join(', ') ?? "Loan request failed";
      AppLogger.log("⚠️ Backend error: $errorMsg");
      throw Exception(errorMsg);
    }

    // 7️⃣ Pretty-print JSON for debugging
    final prettyJson =
        const JsonEncoder.withIndent('  ').convert(loanResponse.toJson());
    AppLogger.log("📦 LoanRequestResponse:\n$prettyJson");

    // 8️⃣ Return parsed response
    return loanResponse;
  } catch (e) {
    final message = ErrorHandler.handleGenericError(e);
    AppLogger.log("❌ Error in requestChamaLoan: $message");
    throw (message);
  }
}



  /// --- REPAY CHAMA LOAN --- ///
  Future<PayLoanResponse> repayChamaLoan({
    required double amount,
  }) async {
    try {
      // 1️⃣ Retrieve logged-in user’s phone number
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;
      // final phoneNumber = '254708075049'; // Uncomment for testing

      if (phoneNumber == null || phoneNumber.isEmpty) {
        throw Exception("User phone number not found in storage.");
      }

      // 2️⃣ Construct endpoint and request body
      final url = "${ApiService.prodEndpointChama}/repay";
      final body = {
        "phone_number": phoneNumber,
        "amount": amount,
      };

      AppLogger.log(
        "📤 Sending loan repayment request for $phoneNumber "
        "amount: $amount",
      );

      // 3️⃣ Send request to backend
      final response = await _apiService.post(url, data: body);

      // 4️⃣ Parse backend JSON response into PayLoanResponse model
      final payLoanResponse = PayLoanResponse.fromJson(response.data);

      // 5️⃣ Handle backend-reported errors
      if (payLoanResponse.errors != null &&
          payLoanResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${payLoanResponse.errors}");
        throw Exception(payLoanResponse.errors!.first.toString());
      }

      // 6️⃣ Log for debugging
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(payLoanResponse.toJson());
      AppLogger.log("📦 PayLoanResponse:\n$prettyJson");

      // 7️⃣ Return parsed model
      return payLoanResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in repayChamaLoan: $message");
      throw (message);
    }
  }

}

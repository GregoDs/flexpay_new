import 'package:dio/dio.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../utils/services/logger.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();
  UserModel? _userModel;

  /// Request OTP
  Future<Response> requestOtp(String phoneNumber) async {
    final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"] ??
        (throw Exception("PROD_ENDPOINT_AUTH is not set in .env"));

    final response = await _apiService.post(
      "$endpoint/send-otp",
      data: {"phone_number": phoneNumber}, 
      requiresAuth: false,
    );

    if (response.data['success'] == true) {
      // Store only phone in temporary UserModel (no token yet)
      _userModel = UserModel(
        token: "",
        user: User(
          id: 0,
          email: "",
          userType: 0,
          isVerified: 0,
          phoneNumber: phoneNumber,
          firstName: "",
          lastName: "",
          username: "",
        ),
      );
      AppLogger.log('[AuthRepo] OTP requested for $phoneNumber');
    }

    return response;
  }

  /// Verify OTP
  Future<Response> verifyOtp(String phoneNumber, String otp) async {
    final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"] ??
        (throw Exception("PROD_ENDPOINT_AUTH is not set in .env"));

    final response = await _apiService.post(
      "$endpoint/verify-otp",
      data: {
        "phone_number": phoneNumber,
        "otp": otp,
      },
      requiresAuth: false,
    );

    if (response.data['success'] == true) {
      // ✅ Use UserModel.fromJson instead of manual parsing
      // _userModel = UserModel.fromJson(
      //   Map<String, dynamic>.from(response.data),
      // );
      // parse whole API response from logging in
      _userModel =
          UserModel.fromLoginResponse(Map<String, dynamic>.from(response.data));

      await SharedPreferencesHelper.saveUserModel(_userModel!);
      await SharedPreferencesHelper.setFirstLaunchDone();
      AppLogger.log('[AuthRepo] Token saved: ${_userModel!.token}');
      AppLogger.log('[AuthRepo] This is the first launch');
    }

    return response;
  }

  /// Get the current cached user
  UserModel? get userModel => _userModel;

  /// Verify Token
  Future<Response> verifyToken(String token) async {
    try {
      final endpoint = dotenv.env["PROD_AUTH_BEARER_TOKEN_ENDPOINT"];
      if (endpoint == null) {
        throw Exception('PROD_AUTH_BEARER_TOKEN_ENDPOINT is not set in .env');
      }
      final String url = "$endpoint/verify-token";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
        token: userModel?.token,
      );

      AppLogger.log('[AuthRepo] Token verification response: ${response.data}');
      return response;
    } catch (e) {
      AppLogger.log("❌ Unexpected error during token verification: $e");
      rethrow;
    }
  }
  

  // register new account
  Future<Response> createAccount(
      String email,
      String password,
      String confirmPassword,
      String firstName,
      String lastName,
      String phoneNumber1,
      String userType,
      String gender,
      String dob,
      String promoterPhone) async {
    final endpoint = dotenv.env["PROD_AUTH_STAGING_REGISTER"] ??
        (throw Exception("PROD_AUTH_STAGING_REGISTER is not set in .env"));

    final response = await _apiService.post(
      "$endpoint/register",
      data: {
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number_1": phoneNumber1,
        "user_type": userType,
        "gender": gender,
        "dob": dob,
        if (promoterPhone.isNotEmpty) "promoter_phone": promoterPhone,
      },
      requiresAuth: false,
    );

    if (response.data['success'] == true) {
      //Parse the ap[i response from signing up
      _userModel = UserModel.fromSignupResponse(
          Map<String, dynamic>.from(response.data));

      await SharedPreferencesHelper.saveUserModel(_userModel!);
      AppLogger.log('[AuthRepo] Token saved: ${_userModel!.token}');
    }
    return response;
  }
}

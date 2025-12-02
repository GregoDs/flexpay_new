import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexpay/features/auth/repo/auth_repo.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  /// ----------------- Register new account -----------------
  Future<void> createAccount(
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
    emit(AuthLoading());
    try {
      final response = await _authRepo.createAccount(
          email,
          password,
          confirmPassword,
          firstName,
          lastName,
          phoneNumber1,
          userType,
          gender,
          dob,
          promoterPhone);

      if (response.data['success'] == true) {
        //use in memory user model directly
        final user = _authRepo.userModel;
        if (user == null) {
          emit(AuthError(errorMessage: "Failed to load user data."));
          return;
        }

        AppLogger.log("🔍 Using in-memory token = ${user.token}");

        //Verify the token with the backend and send user to appropriate screen
        final verifyTokenResponse = await _authRepo.verifyToken(user.token);

        if (verifyTokenResponse.data['success'] == true) {
          emit(AuthUserUpdated(userModel: user));
        } else {
          emit(AuthTokenInvalid());
        }
      } else {
        emit(AuthError(
          errorMessage: ErrorHandler.extractErrorMessage(response.data),
        ));
      }
    } on DioException catch (e) {
      AppLogger.apiError(
        type: "DioException",
        method: e.requestOptions.method,
        uri: e.requestOptions.uri,
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      emit(AuthError(errorMessage: ErrorHandler.handleError(e)));
    } catch (e, stackTrace) {
      AppLogger.log("❌ ERROR in verifyOtp: $e");
      AppLogger.log(stackTrace);
      emit(AuthError(errorMessage: ErrorHandler.handleGenericError(e)));
    }
  }

  /// ----------------- Request OTP -----------------
  Future<void> requestOtp(String phoneNumber, {bool isResend = false}) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.requestOtp(phoneNumber);

      if (response.data['success'] == true) {
        if (isResend) {
          emit(AuthResendOtp(message: 'OTP resent successfully'));
        } else {
          emit(AuthOtpSent(message: 'OTP sent successfully'));
        }
      } else {
        emit(AuthError(
            errorMessage: ErrorHandler.extractErrorMessage(response.data)));
      }
    } on DioException catch (e) {
      AppLogger.apiError(
        type: "DioException",
        method: e.requestOptions.method,
        uri: e.requestOptions.uri,
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      emit(AuthError(errorMessage: ErrorHandler.handleError(e)));
    } catch (e, stackTrace) {
      AppLogger.log("❌ ERROR in requestOtp: $e");
      AppLogger.log(stackTrace);
      emit(AuthError(errorMessage: ErrorHandler.handleGenericError(e)));
    }
  }

  /// ----------------- Verify OTP -----------------
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.verifyOtp(phoneNumber, otp);

      if (response.data['success'] == true) {
        // Use in-memory user model directly
        final user = _authRepo.userModel;
        if (user == null) {
          emit(AuthError(errorMessage: "Failed to load user data."));
          return;
        }

        AppLogger.log("🔍 Using in-memory token = ${user.token}");

        // Verify token with backend

        final verifyTokenResponse = await _authRepo.verifyToken(user.token);

        if (verifyTokenResponse.data['success'] == true) {
          emit(AuthUserUpdated(userModel: user));
        } else {
          emit(AuthTokenInvalid());
        }
      } else {
        emit(AuthError(
          errorMessage: ErrorHandler.extractErrorMessage(response.data),
        ));
      }
    } on DioException catch (e) {
      AppLogger.apiError(
        type: "DioException",
        method: e.requestOptions.method,
        uri: e.requestOptions.uri,
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      emit(AuthError(errorMessage: ErrorHandler.handleError(e)));
    } catch (e, stackTrace) {
      AppLogger.log("❌ ERROR in verifyOtp: $e");
      AppLogger.log(stackTrace);
      emit(AuthError(errorMessage: ErrorHandler.handleGenericError(e)));
    }
  }

  /// ----------------- Verify Token on App Startup -----------------
  Future<void> verifyTokenOnStartup() async {
    emit(AuthLoading());
    try {
      // Prefer SharedPreferences for startup (in-memory may not exist yet)
      final user =
          _authRepo.userModel ?? await SharedPreferencesHelper.getUserModel();

      if (user == null || user.token.isEmpty) {
        emit(AuthTokenInvalid());
        return;
      }

      final response = await _authRepo.verifyToken(user.token);

      if (response.data['success'] == true) {
        emit(AuthUserUpdated(userModel: user));
      } else {
        // Clear invalid token
        await SharedPreferencesHelper.logout();
        emit(AuthTokenInvalid());
      }
    } catch (e, stackTrace) {
      AppLogger.log("❌ ERROR in verifyTokenOnStartup: $e");
      AppLogger.log(stackTrace);
      emit(AuthTokenInvalid());
    }
  }

  /// ----------------- Logout -----------------
  // Future<void> logout() async {
  //   await SharedPreferencesHelper.logout();
  //   _authRepo.userModel = null;
  //   emit(AuthLoggedOut());
  // }
}

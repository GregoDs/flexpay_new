import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthOtpSent extends AuthState {
  final String message;

  AuthOtpSent({required this.message});
}

final class AuthError extends AuthState {
  final String errorMessage;

  AuthError({required this.errorMessage});
}

final class AuthUserUpdated extends AuthState {
  late final UserModel userModel;

  AuthUserUpdated({required this.userModel});

}

final class AuthResendOtp extends AuthState {
  final String message;
  AuthResendOtp({required this.message});
}

final class AuthTokenInvalid extends AuthState{}

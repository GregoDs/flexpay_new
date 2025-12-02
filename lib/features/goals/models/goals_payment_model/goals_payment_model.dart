import 'package:json_annotation/json_annotation.dart';

part 'goals_payment_model.g.dart';

/// ---------------------------
/// 💰 Wallet Payment Response
/// ---------------------------
@JsonSerializable(explicitToJson: true)
class GoalWalletPaymentResponse {
  final GoalWalletPaymentResponse? data; // recursion support (nested data)
  final List<String>? errors;
  final bool success;

  @JsonKey(name: 'status_code')
  final int statusCode;

  GoalWalletPaymentResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  /// Custom factory to handle nested `data` key safely
  factory GoalWalletPaymentResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    GoalWalletPaymentResponse? nested;

    if (rawData is Map<String, dynamic>) {
      nested = GoalWalletPaymentResponse.fromJson(rawData);
    }

    return GoalWalletPaymentResponse(
      data: nested,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      success: json['success'] as bool,
      statusCode: json['status_code'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'errors': errors,
        'success': success,
        'status_code': statusCode,
      };
}

/// ---------------------------
/// 📱 M-Pesa Payment Response
/// ---------------------------
@JsonSerializable()
class GoalMpesaPaymentResponse {
  final String phone;
  final num amount; // can safely be int or double
  final String reference;
  final String description;

  @JsonKey(name: 'CheckoutRequestID')
  final String checkoutRequestId;

  @JsonKey(name: 'MerchantRequestID')
  final String merchantRequestId;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  final int id;

  GoalMpesaPaymentResponse({
    required this.phone,
    required this.amount,
    required this.reference,
    required this.description,
    required this.checkoutRequestId,
    required this.merchantRequestId,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory GoalMpesaPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalMpesaPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GoalMpesaPaymentResponseToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'bk_payment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BkWalletPaymentResponse {
  final BkWalletPaymentResponse? data; // recursion: can hold nested response
  final List<String>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  BkWalletPaymentResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory BkWalletPaymentResponse.fromJson(Map<String, dynamic> json) {
    // Special handling for data field
    final dynamic rawData = json['data'];
    BkWalletPaymentResponse? nested;

    if (rawData is Map<String, dynamic>) {
      nested = BkWalletPaymentResponse.fromJson(rawData);
    }

    return BkWalletPaymentResponse(
      data: nested,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      success: json['success'] as bool,
      statusCode: json['status_code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'errors': errors,
      'success': success,
      'status_code': statusCode,
    };
  }
}

@JsonSerializable()
class BkMpesaPaymentResponse {
  final String phone;
  final num amount; // can be int or double, safer than String
  final String reference;
  final String description;

  @JsonKey(name: 'CheckoutRequestID')
  final String checkoutRequestId;

  @JsonKey(name: 'MerchantRequestID')
  final String merchantRequestId;

  @JsonKey(name: 'user_id')
  final int userId; // backend gives int

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'created_at')
  final String createdAt;

  final int id;

  BkMpesaPaymentResponse({
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

  factory BkMpesaPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$BkMpesaPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BkMpesaPaymentResponseToJson(this);
}
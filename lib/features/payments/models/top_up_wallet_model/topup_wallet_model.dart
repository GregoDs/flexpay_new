import 'package:json_annotation/json_annotation.dart';

part 'topup_wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TopUpWalletHomeResponse {
  // --- Success fields ---
  final String? phone;
  final String? amount;
  final String? reference;
  final String? description;
  @JsonKey(name: "CheckoutRequestID")
  final String? checkoutRequestID;
  @JsonKey(name: "MerchantRequestID")
  final String? merchantRequestID;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "created_at")
  final String? createdAt;
  final int? id;

  // --- Error fields ---
  final int? responseCode;
  final String? responseDescription;
  final String? extra;

  // --- Validation errors ---
  final List<String>? phoneErrors;
  final List<String>? referenceErrors;
  final List<String>? amountErrors;

  TopUpWalletHomeResponse({
    this.phone,
    this.amount,
    this.reference,
    this.description,
    this.checkoutRequestID,
    this.merchantRequestID,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.responseCode,
    this.responseDescription,
    this.extra,
    this.phoneErrors,
    this.referenceErrors,
    this.amountErrors,
  });

  /// ✅ Helper to safely coerce any type to String
  static String? _asString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  /// Custom factory to normalize validation error formats
  factory TopUpWalletHomeResponse.fromJson(Map<String, dynamic> json) {
    return TopUpWalletHomeResponse(
      // success fields
      phone: _asString(json['phone']),
      amount: _asString(json['amount']),
      reference: _asString(json['reference']),
      description: _asString(json['description']),
      checkoutRequestID: _asString(json['CheckoutRequestID']),
      merchantRequestID: _asString(json['MerchantRequestID']),
      userId: _asString(json['user_id']),
      updatedAt: _asString(json['updated_at']),
      createdAt: _asString(json['created_at']),
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),

      // error response fields
      responseCode: json['ResponseCode'] is int
          ? json['ResponseCode']
          : int.tryParse(json['ResponseCode']?.toString() ?? ''),
      responseDescription: _asString(json['ResponseDescription']),
      extra: _asString(json['extra']),

      // validation errors
      phoneErrors: (json['phone'] is List)
          ? (json['phone'] as List).map((e) => e.toString()).toList()
          : null,
      referenceErrors: (json['reference'] is List)
          ? (json['reference'] as List).map((e) => e.toString()).toList()
          : null,
      amountErrors: (json['amount'] is List)
          ? (json['amount'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$TopUpWalletHomeResponseToJson(this);
}
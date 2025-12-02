import 'package:json_annotation/json_annotation.dart';

part 'kapu_topup_model.g.dart';

// Helper to safely convert any JSON type to string
String? _toString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

@JsonSerializable(explicitToJson: true)
class KapuTopUpResponse {
  final KapuTopUpData? data;
  final Map<String, List<String>>? errors;
  final bool? success;

  // For flat responses (no "data" key)
  @JsonKey(fromJson: _toString)
  final String? phone;
  @JsonKey(fromJson: _toString)
  final String? amount;
  @JsonKey(fromJson: _toString)
  final String? reference;
  final String? description;
  @JsonKey(name: 'CheckoutRequestID')
  final String? checkoutRequestID;
  @JsonKey(name: 'MerchantRequestID')
  final String? merchantRequestID;
  @JsonKey(name: 'user_id', fromJson: _toString)
  final String? userId;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  KapuTopUpResponse({
    this.data,
    this.errors,
    this.success,
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
  });

  factory KapuTopUpResponse.fromJson(Map<String, dynamic> json) =>
      _$KapuTopUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KapuTopUpResponseToJson(this);
}

@JsonSerializable()
class KapuTopUpData {
  @JsonKey(fromJson: _toString)
  final String? phone;
  @JsonKey(fromJson: _toString)
  final String? amount;
  @JsonKey(fromJson: _toString)
  final String? reference;
  final String? description;
  @JsonKey(name: 'CheckoutRequestID')
  final String? checkoutRequestID;
  @JsonKey(name: 'MerchantRequestID')
  final String? merchantRequestID;
  @JsonKey(name: 'user_id', fromJson: _toString)
  final String? userId;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  KapuTopUpData({
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
  });

  factory KapuTopUpData.fromJson(Map<String, dynamic> json) =>
      _$KapuTopUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$KapuTopUpDataToJson(this);
}
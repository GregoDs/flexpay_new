import 'package:json_annotation/json_annotation.dart';

part 'kapu_wallet_topup_model.g.dart';

/// Helper to safely convert any JSON type to String
String? _toString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

/// Root response for wallet top-up
@JsonSerializable(explicitToJson: true)
class KapuWalletTopUpResponse {
  final KapuWalletTopUpData? data;
  final Map<String, List<String>>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  KapuWalletTopUpResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory KapuWalletTopUpResponse.fromJson(Map<String, dynamic> json) =>
      _$KapuWalletTopUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KapuWalletTopUpResponseToJson(this);
}

/// Data object inside response
@JsonSerializable(explicitToJson: true)
class KapuWalletTopUpData {
  /// For success messages
  final bool? success;
  final String? message;

  /// Nested wallet data
  final KapuWalletDetails? data;

  /// If data is an array (errors) like ["Insufficient wallet balance."]
  @JsonKey(fromJson: _listFromJson)
  final List<String>? listData;

  KapuWalletTopUpData({
    this.success,
    this.message,
    this.data,
    this.listData,
  });

  factory KapuWalletTopUpData.fromJson(Map<String, dynamic> json) =>
      _$KapuWalletTopUpDataFromJson(json);

  Map<String, dynamic> toJson() => _$KapuWalletTopUpDataToJson(this);

  /// Helper to handle when "data" is actually a list of strings
  static List<String>? _listFromJson(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}

/// Actual wallet info inside "data" for successful top-up
@JsonSerializable()
class KapuWalletDetails {
  @JsonKey(name: 'wallet_type')
  final String? walletType;
  final num? balance;
  final Map<String, List<String>>? amount; // for validation errors like 422

  KapuWalletDetails({this.walletType, this.balance, this.amount});

  factory KapuWalletDetails.fromJson(Map<String, dynamic> json) =>
      _$KapuWalletDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$KapuWalletDetailsToJson(this);
}
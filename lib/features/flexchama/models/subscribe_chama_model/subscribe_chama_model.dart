import 'package:json_annotation/json_annotation.dart';

part 'subscribe_chama_model.g.dart';

/// Root model for Subscribe Chama API response
@JsonSerializable(explicitToJson: true)
class SubscribeChamaResponse {
  final SubscribeChamaData? data;
  final List<String>? messages;
  final List<String>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  SubscribeChamaResponse({
    this.data,
    this.messages,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory SubscribeChamaResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return SubscribeChamaResponse(
      data: rawData is Map<String, dynamic>
          ? SubscribeChamaData.fromJson(rawData)
          : null,
      messages: rawData is List
          ? rawData.map((e) => e.toString()).toList()
          : null,
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList(),
      success: json['success'] as bool,
      statusCode: json['status_code'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.toJson() ?? messages,
        'errors': errors,
        'success': success,
        'status_code': statusCode,
      };
}

/// Data object inside response
@JsonSerializable()
class SubscribeChamaData {
  final int id;

  @JsonKey(name: 'product_name')
  final String productName;

  final String slug;

  @JsonKey(name: 'product_minimum_balance')
  final int productMinimumBalance;

  @JsonKey(name: 'product_category')
  final String productCategory;

  @JsonKey(name: 'product_type')
  final String productType;

  @JsonKey(name: 'product_access_terms')
  final String productAccessTerms;

  @JsonKey(name: 'contribution_terms')
  final String contributionTerms;

  @JsonKey(name: 'expirly_time')
  final String expirlyTime;

  @JsonKey(name: 'txn_ref')
  final String txnRef;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final String uuid;

  @JsonKey(name: 'expiry_date')
  final String expiryDate;

  SubscribeChamaData({
    required this.id,
    required this.productName,
    required this.slug,
    required this.productMinimumBalance,
    required this.productCategory,
    required this.productType,
    required this.productAccessTerms,
    required this.contributionTerms,
    required this.expirlyTime,
    required this.txnRef,
    required this.createdAt,
    required this.updatedAt,
    required this.uuid,
    required this.expiryDate,
  });

  factory SubscribeChamaData.fromJson(Map<String, dynamic> json) =>
      _$SubscribeChamaDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeChamaDataToJson(this);
}

/// -------------------
/// SAVE CHAMA WALLET RESPONSE
/// -------------------
class SaveChamaWalletResponse {
  final dynamic data;          // can be {} or [] depending on backend
  final List<String>? errors;
  final bool? success;
  final int? statusCode;

  SaveChamaWalletResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory SaveChamaWalletResponse.fromJson(Map<String, dynamic> json) {
    // Handle flexible `data` field (can be object or list)
    dynamic parsedData;
    if (json['data'] is Map<String, dynamic>) {
      parsedData = json['data'];
    } else if (json['data'] is List) {
      parsedData = (json['data'] as List).map((e) => e ?? {}).toList();
    } else {
      parsedData = {};
    }

    return SaveChamaWalletResponse(
      data: parsedData,
      errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
      success: json['success'],
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'errors': errors,
      'success': success,
      'status_code': statusCode,
    };
  }
}
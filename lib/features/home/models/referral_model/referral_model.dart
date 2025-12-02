import 'package:json_annotation/json_annotation.dart';

part 'referral_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReferralResponse {
  final dynamic data; // can be ReferralData (object) or List
  final List<dynamic>? errors; // can be List<String> or List<Map<String, dynamic>>
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  ReferralResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ReferralResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralResponseToJson(this);
}

/// Handles the case when "data" is a single object (success scenario)
@JsonSerializable()
class ReferralData {
  @JsonKey(name: 'referral_code')
  final String? referralCode;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'referee_phone_number')
  final String? refereePhoneNumber;

  @JsonKey(name: 'referee_user_id')
  final int? refereeUserId;

  final String? source;

  @JsonKey(name: 'referral_amount')
  final String? referralAmount;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  final int? id;

  ReferralData({
    this.referralCode,
    this.userId,
    this.refereePhoneNumber,
    this.refereeUserId,
    this.source,
    this.referralAmount,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) =>
      _$ReferralDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReferralDataToJson(this);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferralResponse _$ReferralResponseFromJson(Map<String, dynamic> json) =>
    ReferralResponse(
      data: json['data'],
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$ReferralResponseToJson(ReferralResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

ReferralData _$ReferralDataFromJson(Map<String, dynamic> json) => ReferralData(
  referralCode: json['referral_code'] as String?,
  userId: (json['user_id'] as num?)?.toInt(),
  refereePhoneNumber: json['referee_phone_number'] as String?,
  refereeUserId: (json['referee_user_id'] as num?)?.toInt(),
  source: json['source'] as String?,
  referralAmount: json['referral_amount'] as String?,
  updatedAt: json['updated_at'] as String?,
  createdAt: json['created_at'] as String?,
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReferralDataToJson(ReferralData instance) =>
    <String, dynamic>{
      'referral_code': instance.referralCode,
      'user_id': instance.userId,
      'referee_phone_number': instance.refereePhoneNumber,
      'referee_user_id': instance.refereeUserId,
      'source': instance.source,
      'referral_amount': instance.referralAmount,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'id': instance.id,
    };

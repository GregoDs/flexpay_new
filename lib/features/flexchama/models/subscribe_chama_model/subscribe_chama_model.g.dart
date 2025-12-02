// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_chama_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeChamaResponse _$SubscribeChamaResponseFromJson(
  Map<String, dynamic> json,
) => SubscribeChamaResponse(
  data: json['data'] == null
      ? null
      : SubscribeChamaData.fromJson(json['data'] as Map<String, dynamic>),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$SubscribeChamaResponseToJson(
  SubscribeChamaResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'messages': instance.messages,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

SubscribeChamaData _$SubscribeChamaDataFromJson(Map<String, dynamic> json) =>
    SubscribeChamaData(
      id: (json['id'] as num).toInt(),
      productName: json['product_name'] as String,
      slug: json['slug'] as String,
      productMinimumBalance: (json['product_minimum_balance'] as num).toInt(),
      productCategory: json['product_category'] as String,
      productType: json['product_type'] as String,
      productAccessTerms: json['product_access_terms'] as String,
      contributionTerms: json['contribution_terms'] as String,
      expirlyTime: json['expirly_time'] as String,
      txnRef: json['txn_ref'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      uuid: json['uuid'] as String,
      expiryDate: json['expiry_date'] as String,
    );

Map<String, dynamic> _$SubscribeChamaDataToJson(SubscribeChamaData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'slug': instance.slug,
      'product_minimum_balance': instance.productMinimumBalance,
      'product_category': instance.productCategory,
      'product_type': instance.productType,
      'product_access_terms': instance.productAccessTerms,
      'contribution_terms': instance.contributionTerms,
      'expirly_time': instance.expirlyTime,
      'txn_ref': instance.txnRef,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'uuid': instance.uuid,
      'expiry_date': instance.expiryDate,
    };

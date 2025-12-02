// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_topup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KapuTopUpResponse _$KapuTopUpResponseFromJson(Map<String, dynamic> json) =>
    KapuTopUpResponse(
      data: json['data'] == null
          ? null
          : KapuTopUpData.fromJson(json['data'] as Map<String, dynamic>),
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      success: json['success'] as bool?,
      phone: _toString(json['phone']),
      amount: _toString(json['amount']),
      reference: _toString(json['reference']),
      description: json['description'] as String?,
      checkoutRequestID: json['CheckoutRequestID'] as String?,
      merchantRequestID: json['MerchantRequestID'] as String?,
      userId: _toString(json['user_id']),
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KapuTopUpResponseToJson(KapuTopUpResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'phone': instance.phone,
      'amount': instance.amount,
      'reference': instance.reference,
      'description': instance.description,
      'CheckoutRequestID': instance.checkoutRequestID,
      'MerchantRequestID': instance.merchantRequestID,
      'user_id': instance.userId,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
      'id': instance.id,
    };

KapuTopUpData _$KapuTopUpDataFromJson(Map<String, dynamic> json) =>
    KapuTopUpData(
      phone: _toString(json['phone']),
      amount: _toString(json['amount']),
      reference: _toString(json['reference']),
      description: json['description'] as String?,
      checkoutRequestID: json['CheckoutRequestID'] as String?,
      merchantRequestID: json['MerchantRequestID'] as String?,
      userId: _toString(json['user_id']),
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KapuTopUpDataToJson(KapuTopUpData instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'amount': instance.amount,
      'reference': instance.reference,
      'description': instance.description,
      'CheckoutRequestID': instance.checkoutRequestID,
      'MerchantRequestID': instance.merchantRequestID,
      'user_id': instance.userId,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
      'id': instance.id,
    };

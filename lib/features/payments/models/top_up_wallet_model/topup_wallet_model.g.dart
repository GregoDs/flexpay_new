// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopUpWalletHomeResponse _$TopUpWalletHomeResponseFromJson(
  Map<String, dynamic> json,
) => TopUpWalletHomeResponse(
  phone: json['phone'] as String?,
  amount: json['amount'] as String?,
  reference: json['reference'] as String?,
  description: json['description'] as String?,
  checkoutRequestID: json['CheckoutRequestID'] as String?,
  merchantRequestID: json['MerchantRequestID'] as String?,
  userId: json['user_id'] as String?,
  updatedAt: json['updated_at'] as String?,
  createdAt: json['created_at'] as String?,
  id: (json['id'] as num?)?.toInt(),
  responseCode: (json['responseCode'] as num?)?.toInt(),
  responseDescription: json['responseDescription'] as String?,
  extra: json['extra'] as String?,
  phoneErrors: (json['phoneErrors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  referenceErrors: (json['referenceErrors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  amountErrors: (json['amountErrors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TopUpWalletHomeResponseToJson(
  TopUpWalletHomeResponse instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'amount': instance.amount,
  'reference': instance.reference,
  'description': instance.description,
  'CheckoutRequestID': instance.checkoutRequestID,
  'MerchantRequestID': instance.merchantRequestID,
  'user_id': instance.userId,
  'updated_at': instance.updatedAt,
  'created_at': instance.createdAt,
  'id': instance.id,
  'responseCode': instance.responseCode,
  'responseDescription': instance.responseDescription,
  'extra': instance.extra,
  'phoneErrors': instance.phoneErrors,
  'referenceErrors': instance.referenceErrors,
  'amountErrors': instance.amountErrors,
};

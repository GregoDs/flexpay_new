// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bk_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BkWalletPaymentResponse _$BkWalletPaymentResponseFromJson(
  Map<String, dynamic> json,
) => BkWalletPaymentResponse(
  data: json['data'] == null
      ? null
      : BkWalletPaymentResponse.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$BkWalletPaymentResponseToJson(
  BkWalletPaymentResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

BkMpesaPaymentResponse _$BkMpesaPaymentResponseFromJson(
  Map<String, dynamic> json,
) => BkMpesaPaymentResponse(
  phone: json['phone'] as String,
  amount: json['amount'] as num,
  reference: json['reference'] as String,
  description: json['description'] as String,
  checkoutRequestId: json['CheckoutRequestID'] as String,
  merchantRequestId: json['MerchantRequestID'] as String,
  userId: (json['user_id'] as num).toInt(),
  updatedAt: json['updated_at'] as String,
  createdAt: json['created_at'] as String,
  id: (json['id'] as num).toInt(),
);

Map<String, dynamic> _$BkMpesaPaymentResponseToJson(
  BkMpesaPaymentResponse instance,
) => <String, dynamic>{
  'phone': instance.phone,
  'amount': instance.amount,
  'reference': instance.reference,
  'description': instance.description,
  'CheckoutRequestID': instance.checkoutRequestId,
  'MerchantRequestID': instance.merchantRequestId,
  'user_id': instance.userId,
  'updated_at': instance.updatedAt,
  'created_at': instance.createdAt,
  'id': instance.id,
};

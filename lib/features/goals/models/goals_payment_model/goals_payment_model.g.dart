// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalWalletPaymentResponse _$GoalWalletPaymentResponseFromJson(
  Map<String, dynamic> json,
) => GoalWalletPaymentResponse(
  data: json['data'] == null
      ? null
      : GoalWalletPaymentResponse.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$GoalWalletPaymentResponseToJson(
  GoalWalletPaymentResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

GoalMpesaPaymentResponse _$GoalMpesaPaymentResponseFromJson(
  Map<String, dynamic> json,
) => GoalMpesaPaymentResponse(
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

Map<String, dynamic> _$GoalMpesaPaymentResponseToJson(
  GoalMpesaPaymentResponse instance,
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

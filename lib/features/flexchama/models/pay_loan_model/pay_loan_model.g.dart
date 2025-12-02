// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_loan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayLoanResponse _$PayLoanResponseFromJson(Map<String, dynamic> json) =>
    PayLoanResponse(
      data: json['data'],
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$PayLoanResponseToJson(PayLoanResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

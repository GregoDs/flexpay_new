// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_savings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawChamaSavingsResponse _$WithdrawChamaSavingsResponseFromJson(
  Map<String, dynamic> json,
) => WithdrawChamaSavingsResponse(
  data: json['data'],
  errors: json['errors'] as List<dynamic>?,
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$WithdrawChamaSavingsResponseToJson(
  WithdrawChamaSavingsResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

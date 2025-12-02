// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChamaLoanRequestResponse _$ChamaLoanRequestResponseFromJson(
  Map<String, dynamic> json,
) => ChamaLoanRequestResponse(
  data: json['data'],
  errors: json['errors'] as List<dynamic>?,
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$ChamaLoanRequestResponseToJson(
  ChamaLoanRequestResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

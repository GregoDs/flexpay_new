// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refunds_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundResponse _$RefundResponseFromJson(Map<String, dynamic> json) =>
    RefundResponse(
      data: json['data'],
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$RefundResponseToJson(RefundResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

NestedRefundResponse _$NestedRefundResponseFromJson(
  Map<String, dynamic> json,
) => NestedRefundResponse(
  data: json['data'],
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$NestedRefundResponseToJson(
  NestedRefundResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

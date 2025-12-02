// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelBookingResponse _$CancelBookingResponseFromJson(
  Map<String, dynamic> json,
) => CancelBookingResponse(
  data: json['data'],
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$CancelBookingResponseToJson(
  CancelBookingResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

CancelBookingNestedData _$CancelBookingNestedDataFromJson(
  Map<String, dynamic> json,
) => CancelBookingNestedData(
  data: json['data'] as List<dynamic>?,
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$CancelBookingNestedDataToJson(
  CancelBookingNestedData instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

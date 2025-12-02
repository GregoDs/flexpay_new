// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_shops_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutletResponse _$OutletResponseFromJson(Map<String, dynamic> json) =>
    OutletResponse(
      data: json['data'],
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OutletResponseToJson(OutletResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

Outlet _$OutletFromJson(Map<String, dynamic> json) => Outlet(
  id: (json['id'] as num?)?.toInt(),
  outletName: json['outlet_name'] as String?,
);

Map<String, dynamic> _$OutletToJson(Outlet instance) => <String, dynamic>{
  'id': instance.id,
  'outlet_name': instance.outletName,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_debit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitResponseModel _$DebitResponseModelFromJson(Map<String, dynamic> json) =>
    DebitResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as List<dynamic>?,
      errors: json['errors'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DebitResponseModelToJson(DebitResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

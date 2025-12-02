// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KapuTransferModel _$KapuTransferModelFromJson(Map<String, dynamic> json) =>
    KapuTransferModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      errors: json['errors'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$KapuTransferModelToJson(KapuTransferModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'errors': instance.errors,
    };

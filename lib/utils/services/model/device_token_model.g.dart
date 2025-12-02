// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceTokenModel _$DeviceTokenModelFromJson(Map<String, dynamic> json) =>
    DeviceTokenModel(
      deviceToken: json['device_token'] as String,
      deviceType: json['device_type'] as String,
      deviceId: json['device_id'] as String,
      deviceName: json['device_name'] as String?,
      deviceModel: json['device_model'] as String?,
      deviceOs: json['device_os'] as String?,
      deviceOsVersion: json['device_os_version'] as String?,
      appVersion: json['app_version'] as String?,
      appVersionCode: json['app_version_code'] as String?,
    );

Map<String, dynamic> _$DeviceTokenModelToJson(DeviceTokenModel instance) =>
    <String, dynamic>{
      'device_token': instance.deviceToken,
      'device_type': instance.deviceType,
      'device_id': instance.deviceId,
      'device_name': instance.deviceName,
      'device_model': instance.deviceModel,
      'device_os': instance.deviceOs,
      'device_os_version': instance.deviceOsVersion,
      'app_version': instance.appVersion,
      'app_version_code': instance.appVersionCode,
    };

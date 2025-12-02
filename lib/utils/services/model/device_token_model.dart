import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'device_token_model.g.dart'; 

@JsonSerializable()
class DeviceTokenModel {
  @JsonKey(name: 'device_token')
  final String deviceToken;

  @JsonKey(name: 'device_type')
  final String deviceType;

  @JsonKey(name: 'device_id')
  final String deviceId;

  @JsonKey(name: 'device_name')
  final String? deviceName;

  @JsonKey(name: 'device_model')
  final String? deviceModel;

  @JsonKey(name: 'device_os')
  final String? deviceOs;

  @JsonKey(name: 'device_os_version')
  final String? deviceOsVersion;

  @JsonKey(name: 'app_version')
  
  final String? appVersion;

  @JsonKey(name: 'app_version_code')
  final String? appVersionCode;

  DeviceTokenModel({
    required this.deviceToken,
    required this.deviceType,
    required this.deviceId,
    this.deviceName,
    this.deviceModel,
    this.deviceOs,
    this.deviceOsVersion,
    this.appVersion,
    this.appVersionCode,
  });

  /// From JSON
  factory DeviceTokenModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceTokenModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$DeviceTokenModelToJson(this);

  /// Factory generator to auto-generate all device + app info
  static Future<DeviceTokenModel> getDeviceToken(String fcmToken) async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    String deviceType = '';
    String deviceId = '';
    String? deviceModel;
    String? deviceName;
    String? deviceOs;
    String? deviceOsVersion;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceType = 'android';
        deviceId = androidInfo.id;
        deviceModel = androidInfo.model;
        deviceName = androidInfo.device;
        deviceOs = 'Android';
        deviceOsVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceType = 'ios';
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceModel = iosInfo.utsname.machine;
        deviceName = iosInfo.name;
        deviceOs = 'iOS';
        deviceOsVersion = iosInfo.systemVersion;
      }
    } catch (e) {
      print('Error fetching device info: $e');
    }

    return DeviceTokenModel(
      deviceToken: fcmToken,
      deviceType: deviceType,
      deviceId: deviceId,
      deviceName: deviceName,
      deviceModel: deviceModel,
      deviceOs: deviceOs,
      deviceOsVersion: deviceOsVersion,
      appVersion: packageInfo.version,
      appVersionCode: packageInfo.buildNumber,
    );
  }
}
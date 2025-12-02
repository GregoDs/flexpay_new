// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_wallet_topup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KapuWalletTopUpResponse _$KapuWalletTopUpResponseFromJson(
  Map<String, dynamic> json,
) => KapuWalletTopUpResponse(
  data: json['data'] == null
      ? null
      : KapuWalletTopUpData.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$KapuWalletTopUpResponseToJson(
  KapuWalletTopUpResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

KapuWalletTopUpData _$KapuWalletTopUpDataFromJson(Map<String, dynamic> json) =>
    KapuWalletTopUpData(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : KapuWalletDetails.fromJson(json['data'] as Map<String, dynamic>),
      listData: KapuWalletTopUpData._listFromJson(json['listData']),
    );

Map<String, dynamic> _$KapuWalletTopUpDataToJson(
  KapuWalletTopUpData instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.toJson(),
  'listData': instance.listData,
};

KapuWalletDetails _$KapuWalletDetailsFromJson(Map<String, dynamic> json) =>
    KapuWalletDetails(
      walletType: json['wallet_type'] as String?,
      balance: json['balance'] as num?,
      amount: (json['amount'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$KapuWalletDetailsToJson(KapuWalletDetails instance) =>
    <String, dynamic>{
      'wallet_type': instance.walletType,
      'balance': instance.balance,
      'amount': instance.amount,
    };

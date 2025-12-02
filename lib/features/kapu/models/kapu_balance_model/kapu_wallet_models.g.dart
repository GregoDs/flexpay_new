// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_wallet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KapuWalletBalances _$KapuWalletBalancesFromJson(Map<String, dynamic> json) =>
    KapuWalletBalances(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : WalletData.fromJson(json['data'] as Map<String, dynamic>),
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$KapuWalletBalancesToJson(KapuWalletBalances instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data?.toJson(),
      'errors': instance.errors,
    };

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  walletType: json['wallet_type'] as String,
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) =>
    <String, dynamic>{
      'wallet_type': instance.walletType,
      'balance': instance.balance,
    };

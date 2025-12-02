// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_wallets_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllWalletsKapuModel _$AllWalletsKapuModelFromJson(Map<String, dynamic> json) =>
    AllWalletsKapuModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => KapuWallet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllWalletsKapuModelToJson(
  AllWalletsKapuModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.map((e) => e.toJson()).toList(),
};

KapuWallet _$KapuWalletFromJson(Map<String, dynamic> json) => KapuWallet(
  walletName: json['wallet_name'] as String,
  walletType: json['wallet_type'] as String,
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$KapuWalletToJson(KapuWallet instance) =>
    <String, dynamic>{
      'wallet_name': instance.walletName,
      'wallet_type': instance.walletType,
      'balance': instance.balance,
    };

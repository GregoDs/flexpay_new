// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletResponse _$WalletResponseFromJson(Map<String, dynamic> json) =>
    WalletResponse(
      data: json['data'] == null
          ? null
          : WalletData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$WalletResponseToJson(WalletResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  walletAccount: json['wallet_account'] == null
      ? null
      : WalletAccount.fromJson(json['wallet_account'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) =>
    <String, dynamic>{'wallet_account': instance.walletAccount?.toJson()};

WalletAccount _$WalletAccountFromJson(Map<String, dynamic> json) =>
    WalletAccount(
      id: (json['id'] as num?)?.toInt(),
      walletBalance: json['wallet_balance'] == null
          ? null
          : WalletBalance.fromJson(
              json['wallet_balance'] as Map<String, dynamic>,
            ),
      walletRefundBalance: (json['wallet_refund_balance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalletAccountToJson(WalletAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet_balance': instance.walletBalance?.toJson(),
      'wallet_refund_balance': instance.walletRefundBalance,
    };

WalletBalance _$WalletBalanceFromJson(Map<String, dynamic> json) =>
    WalletBalance(
      id: (json['id'] as num?)?.toInt(),
      totalCredit: (json['total_credit'] as num?)?.toInt(),
      totalDebit: (json['total_debit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalletBalanceToJson(WalletBalance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total_credit': instance.totalCredit,
      'total_debit': instance.totalDebit,
    };

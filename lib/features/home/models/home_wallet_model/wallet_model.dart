import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletResponse {
  final WalletData? data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  WalletResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WalletData {
  @JsonKey(name: 'wallet_account')
  final WalletAccount? walletAccount;

  WalletData({this.walletAccount});

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WalletAccount {
  final int? id;
  @JsonKey(name: 'wallet_balance')
  final WalletBalance? walletBalance;
  @JsonKey(name: 'wallet_refund_balance')
  final int? walletRefundBalance;

  // ✅ Removed unused fields:
  // - user_id, account_number, account_status
  // - created_at, updated_at
  // - wallet_credit (can be large array)
  // - wallet_debit (can be large array)

  WalletAccount({
    this.id,
    this.walletBalance,
    this.walletRefundBalance,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);

  Map<String, dynamic> toJson() => _$WalletAccountToJson(this);
}

@JsonSerializable()
class WalletBalance {
  final int? id;
  @JsonKey(name: 'total_credit')
  final int? totalCredit;
  @JsonKey(name: 'total_debit')
  final int? totalDebit;

  
  int get balance => (totalCredit ?? 0) - (totalDebit ?? 0);


  WalletBalance({
    this.id,
    this.totalCredit,
    this.totalDebit,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBalanceToJson(this);
}


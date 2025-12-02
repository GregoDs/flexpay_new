import 'package:json_annotation/json_annotation.dart';

part 'kapu_wallet_models.g.dart';

@JsonSerializable(explicitToJson: true)
class KapuWalletBalances {
  final bool success;
  final String message;
  final WalletData? data;
  final Map<String, List<String>>? errors;

  KapuWalletBalances({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  /// Factory to create from JSON
  factory KapuWalletBalances.fromJson(Map<String, dynamic> json) =>
      _$KapuWalletBalancesFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$KapuWalletBalancesToJson(this);
}

@JsonSerializable()
class WalletData {
  @JsonKey(name: 'wallet_type')
  final String walletType;

  final double balance;

  WalletData({
    required this.walletType,
    required this.balance,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}
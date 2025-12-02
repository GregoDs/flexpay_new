import 'package:json_annotation/json_annotation.dart';

part 'all_wallets_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AllWalletsKapuModel {
  final bool success;
  final String message;
  final List<KapuWallet> data;

  AllWalletsKapuModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AllWalletsKapuModel.fromJson(Map<String, dynamic> json) =>
      _$AllWalletsKapuModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllWalletsKapuModelToJson(this);
}

@JsonSerializable()
class KapuWallet {
  @JsonKey(name: 'wallet_name')
  final String walletName;

  @JsonKey(name: 'wallet_type')
  final String walletType;

  final double balance;

  KapuWallet({
    required this.walletName,
    required this.walletType,
    required this.balance,
  });

  factory KapuWallet.fromJson(Map<String, dynamic> json) =>
      _$KapuWalletFromJson(json);

  Map<String, dynamic> toJson() => _$KapuWalletToJson(this);
}
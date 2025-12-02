import 'package:json_annotation/json_annotation.dart';

part 'transactions_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LatestTransactionsResponse {
  final List<TransactionData> data;
  final List<dynamic> errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  LatestTransactionsResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory LatestTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$LatestTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LatestTransactionsResponseToJson(this);
}

@JsonSerializable()
class TransactionData {
  @JsonKey(name: 'payment_amount')
  final double paymentAmount;

  @JsonKey(name: 'product_name')
  final String productName;

  final String date;

  TransactionData({
    required this.paymentAmount,
    required this.productName,
    required this.date,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}
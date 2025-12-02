// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestTransactionsResponse _$LatestTransactionsResponseFromJson(
  Map<String, dynamic> json,
) => LatestTransactionsResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => TransactionData.fromJson(e as Map<String, dynamic>))
      .toList(),
  errors: json['errors'] as List<dynamic>,
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$LatestTransactionsResponseToJson(
  LatestTransactionsResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      paymentAmount: (json['payment_amount'] as num).toDouble(),
      productName: json['product_name'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'payment_amount': instance.paymentAmount,
      'product_name': instance.productName,
      'date': instance.date,
    };

import 'package:json_annotation/json_annotation.dart';

part 'refunds_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RefundResponse {
  final dynamic data; // can be null, [] or a nested object
  final List<String>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  RefundResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) =>
      _$RefundResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefundResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NestedRefundResponse {
  final dynamic data;
  final List<String>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  NestedRefundResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory NestedRefundResponse.fromJson(Map<String, dynamic> json) =>
      _$NestedRefundResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NestedRefundResponseToJson(this);
}
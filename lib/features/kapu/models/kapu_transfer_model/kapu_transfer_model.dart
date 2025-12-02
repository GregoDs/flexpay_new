import 'package:json_annotation/json_annotation.dart';

part 'kapu_transfer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class KapuTransferModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  KapuTransferModel({
    required this.success,
    required this.message,
    this.errors,
  });

  /// Factory constructor to create instance from JSON
  factory KapuTransferModel.fromJson(Map<String, dynamic> json) =>
      _$KapuTransferModelFromJson(json);

  /// Convert this model to JSON
  Map<String, dynamic> toJson() => _$KapuTransferModelToJson(this);
}
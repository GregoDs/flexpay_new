import 'package:json_annotation/json_annotation.dart';

part 'kapu_debit_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DebitResponseModel {
  final bool success;
  final String message;

  /// Some responses return `data`, others return `errors`
  final List<dynamic>? data;
  final Map<String, dynamic>? errors;

  DebitResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  /// Factory constructor for creating a new instance from JSON
  factory DebitResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DebitResponseModelFromJson(json);

  /// Method to convert this object to JSON
  Map<String, dynamic> toJson() => _$DebitResponseModelToJson(this);
}
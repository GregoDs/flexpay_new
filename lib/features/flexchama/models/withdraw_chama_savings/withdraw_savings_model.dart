import 'package:json_annotation/json_annotation.dart';

part 'withdraw_savings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WithdrawChamaSavingsResponse {
  final dynamic data;
  final List<dynamic>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  WithdrawChamaSavingsResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  /// Helper method to extract a user-friendly message
  String? get message {
    // Case 1: When data is a list of success messages
    if (data is List && data.isNotEmpty) {
      return data.first.toString();
    }

    // Case 2: When data contains errors
    if (data is Map && data['errors'] != null) {
      final Map<String, dynamic> errs = Map<String, dynamic>.from(data['errors']);
      final messages = errs.entries
          .map((e) => '${e.key}: ${(e.value as List).join(", ")}')
          .join('\n');
      return messages;
    }

    return null;
  }

  factory WithdrawChamaSavingsResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawChamaSavingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawChamaSavingsResponseToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'pay_loan_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PayLoanResponse {
  final dynamic data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  PayLoanResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  /// Safely extracts a readable message for the UI
  String get message {
    // ✅ Case 1: data is a list (like ["Please wait for mpesa confirmation"])
    if (data is List && (data as List).isNotEmpty) {
      final first = (data as List).first;
      if (first is String && first.trim().isNotEmpty) return first;
      return first.toString();
    }

    // ✅ Case 2: data is a string
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    // ✅ Case 3: data is a map that contains a message key
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    // ✅ Default fallback
    return "Loan repayment completed successfully.";
  }

  factory PayLoanResponse.fromJson(Map<String, dynamic> json) =>
      _$PayLoanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayLoanResponseToJson(this);
}
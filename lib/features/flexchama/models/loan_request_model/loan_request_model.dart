import 'package:json_annotation/json_annotation.dart';

part 'loan_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChamaLoanRequestResponse {
  final dynamic data; // Sometimes it's a List<String>, sometimes [{}]
  final List<dynamic>? errors;
  final bool success;

  @JsonKey(name: 'status_code')
  final int statusCode;

  ChamaLoanRequestResponse({
    required this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  /// ✅ Helper getters for easier access
  String? get message {
    if (data is List && data.isNotEmpty && data.first is String) {
      return data.first as String;
    }
    return null;
  }

  List<String>? get errorMessages {
    if (errors == null) return null;
    return errors!.map((e) => e.toString()).toList();
  }

  /// ✅ JSON serialization helpers
  factory ChamaLoanRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$ChamaLoanRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaLoanRequestResponseToJson(this);
}
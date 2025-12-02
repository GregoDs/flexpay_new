import 'package:json_annotation/json_annotation.dart';

part 'cancel_booking_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CancelBookingResponse {
  final dynamic data; // Can be [], null, or nested object
  final List<String>? errors;
  final bool success;
  @JsonKey(name: "status_code")
  final int statusCode;

  CancelBookingResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  /// Factory constructor for creating a new instance from a map
  factory CancelBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingResponseFromJson(json);

  /// Method for converting the instance back to a map
  Map<String, dynamic> toJson() => _$CancelBookingResponseToJson(this);
}

/// If data itself is an object (case 2), we capture it here
@JsonSerializable()
class CancelBookingNestedData {
  final List<dynamic>? data;
  final List<String>? errors;
  final bool success;
  @JsonKey(name: "status_code")
  final int statusCode;

  CancelBookingNestedData({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory CancelBookingNestedData.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingNestedDataFromJson(json);

  Map<String, dynamic> toJson() => _$CancelBookingNestedDataToJson(this);
}
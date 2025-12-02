class ApiResponse {
  final List<dynamic> data;
  final List<String> errors;
  final bool success;
  final int statusCode;

  ApiResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: json['data'] ?? [],
      errors: List<String>.from(json['errors'] ?? []),
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 500,
    );
  }
}
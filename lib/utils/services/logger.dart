import 'package:flutter/foundation.dart'; // For kDebugMode

class AppLogger {
  //logs only in debug mode
  static void log(dynamic message) {
    if (kDebugMode) {
      debugPrint(message.toString());
    }
  }

  //Logs Api requests in debug mode
  static void apiRequest({
    required String method,
    required Uri uri,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
    dynamic body,
  }) {
    if (kDebugMode) {
      log('➡️ REQUEST: $method $uri');
      if (headers != null) log('Headers: ${_redactHeaders(headers)}');
      if (query != null && query.isNotEmpty) log('Query: $query');
      if (body != null) log('Body: ${_shorten(body)}');
      }
  }


/// Logs API responses in debug mode
  static void apiResponse({
    required int? statusCode,
    required String method,
    required Uri uri,
    dynamic data,
  }) {
    if (kDebugMode) {
      log('✅ RESPONSE: $statusCode $method $uri');
      if (data != null) log('Data: ${_shorten(data)}');
    }
  }

  /// Logs API errors in debug mode
  static void apiError({
    required String type,
    required String method,
    required Uri uri,
    int? statusCode,
    dynamic data,
  }) {
    if (kDebugMode) {
      log('❌ ERROR: $type $method $uri');
      if (statusCode != null) log('Status: $statusCode');
      if (data != null) log('Error Data: ${_shorten(data)}');
    }
  }

  // Helpers
  static String _redactHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    if (copy.containsKey('Authorization')) {
      copy['Authorization'] = 'Bearer ***';
    }
    return copy.toString();
  }

  static String _shorten(dynamic data, {int max = 1000}) {
    try {
      final s = data is String ? data : data.toString();
      return s.length > max ? '${s.substring(0, max)}...' : s;
    } catch (_) {
      return '<unprintable payload>';
    }
  }
}

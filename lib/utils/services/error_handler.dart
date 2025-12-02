import 'package:dio/dio.dart';


class GlobalCircuitBreaker {
  static final Map<String, int> _failureCount = {};
  static final Map<String, DateTime?> _lastFailureTime = {};

  static const int MAX_FAILURES = 3;
  static const Duration BLOCK_DURATION = Duration(minutes: 2);
  static const Duration ERROR_THROTTLE = Duration(seconds: 5);

  static bool canExecute(String endpoint) {
    final key = _getEndpointKey(endpoint);
    final lastFailure = _lastFailureTime[key];
    final failures = _failureCount[key] ?? 0;

    
    if (lastFailure == null) return true;

    
    if (DateTime.now().difference(lastFailure) < ERROR_THROTTLE) {
      return false;
    }

    
    if (failures >= MAX_FAILURES &&
        DateTime.now().difference(lastFailure) < BLOCK_DURATION) {
      return false;
    }

    
    if (DateTime.now().difference(lastFailure) >= BLOCK_DURATION) {
      _failureCount[key] = 0;
      _lastFailureTime[key] = null;
    }

    return true;
  }

  static void recordFailure(String endpoint) {
    final key = _getEndpointKey(endpoint);
    _failureCount[key] = (_failureCount[key] ?? 0) + 1;
    _lastFailureTime[key] = DateTime.now();
  }

  static void recordSuccess(String endpoint) {
    final key = _getEndpointKey(endpoint);
    _failureCount[key] = 0;
    _lastFailureTime[key] = null;
  }

  static String _getEndpointKey(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.host}${uri.path}';
    } catch (_) {
      return url;
    }
  }

  static bool isBlocked(String endpoint) {
    final key = _getEndpointKey(endpoint);
    final failures = _failureCount[key] ?? 0;
    final lastFailure = _lastFailureTime[key];

    if (lastFailure == null) return false;

    return failures >= MAX_FAILURES &&
        DateTime.now().difference(lastFailure) < BLOCK_DURATION;
  }
}

class ErrorHandler {
  static Exception formatDioError(DioException error) {
    final url = error.requestOptions.uri.toString();

    
    if (error.response?.statusCode == 500) {
      GlobalCircuitBreaker.recordFailure(url);
    }

    if (error.response?.data is Map<String, dynamic>) {
      final message = extractErrorMessage(error.response!.data!);
      return Exception(message);
    }

    final fallback = handleError(error);
    return Exception(fallback);
  }

  

  static String extractErrorMessage(Map<String, dynamic> responseData) {
    try {
      if (responseData['errors'] is List &&
          (responseData['errors'] as List).isNotEmpty) {
        return (responseData['errors'] as List).first.toString();
      }
      if (responseData['data'] is List &&
          (responseData['data'] as List).isNotEmpty) {
        return (responseData['data'] as List).first.toString();
      }
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }
      return 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }

  static String handleError(DioException error) {
    final url = error.requestOptions.uri.toString();

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout. Please check your internet connection.";
      case DioExceptionType.sendTimeout:
        return "Send timeout. Please check your internet connection.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      default:
        break;
    }

    switch (error.response?.statusCode) {
      case 400:
        return "Bad request. Please check your input.";
      case 401:
        return "Unauthorized. Please log in again.";
      case 403:
        return "Forbidden. You don't have permission.";
      case 404:
        return "Resource not found.";
      case 422:
        return "Validation error. Please check your input.";
      case 500:
        
        if (GlobalCircuitBreaker.isBlocked(url)) {
          return "Service temporarily unavailable. Please try again in a few minutes.";
        }
        return "Internal server error. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
    }

    return "An unexpected error occurred. Please try again.";
  }

  static String handleGenericError(dynamic error) {
    final raw = error.toString();
    return raw.replaceFirst(' ', '').trim();
  }
}

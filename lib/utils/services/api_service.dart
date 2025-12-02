import 'dart:convert';
import 'package:flexpay/exports.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:http/http.dart' as http;

/// Global interceptor to prevent infinite retries and implement circuit breaker
class CircuitBreakerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final url = options.uri.toString();

    // Check if this endpoint is blocked by circuit breaker
    if (!GlobalCircuitBreaker.canExecute(url)) {
      AppLogger.log('🚫 Request blocked by circuit breaker: $url');

      // Return a custom error instead of making the request
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
        message:
            'Service temporarily unavailable. Please try again in a few minutes.',
      );
      handler.reject(error);
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final url = response.requestOptions.uri.toString();

    // Record success for circuit breaker
    if (response.statusCode != null && response.statusCode! < 500) {
      GlobalCircuitBreaker.recordSuccess(url);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final url = err.requestOptions.uri.toString();

    // Only log 500 errors once every 10 seconds to prevent spam
    if (err.response?.statusCode == 500) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now % 10000 < 1000) {
        AppLogger.apiError(
          type: 'DioException',
          method: err.requestOptions.method,
          uri: err.requestOptions.uri,
          statusCode: err.response?.statusCode,
          data: 'Server error - logging throttled',
        );
      }
    }

    handler.next(err);
  }
}

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  ApiService() {
    // Add the global circuit breaker interceptor
    _dio.interceptors.add(CircuitBreakerInterceptor());
  }

  // Base URLs
  static String prodEndpointAuth = dotenv.env["PROD_ENDPOINT_AUTH"]!;
  static String prodEndpointBookings = dotenv.env['PROD_ENDPOINT_BOOKINGS']!;
  static String prodEndpointChama = dotenv.env['PROD_ENDPOINT_CHAMA']!;
  static String prodEndpointWallet = dotenv.env['PROD_ENDPOINT_WALLET']!;
  static String prodEndpointBookingsTransactions =
      dotenv.env['PROD_ENDPOINT_BOOKINGS_TRANSACTIONS']!;
  static String prodEndpointPayments = dotenv.env['PROD_ENDPOINT_PAYMENTS']!;
  static String prodEndpointGoals = dotenv.env['PROD_ENDPOINT_GOALS']!;
  static String prodEndpointKapuWallet =
      dotenv.env['PROD_ENDPOINT_KAPU_WALLET']!;
  static String prodEndpointBookingsKapu =
      dotenv.env['PROD_ENDPOINT_BOOKINGS_KAPU']!;
  static String prodEndpointKapuWalletShops =
      dotenv.env['PROD_ENDPOINT_KAPU_WALLET_SHOPS']!;

  // Generic GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    String? token,
  }) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      AppLogger.apiRequest(
        method: 'GET',
        uri: Uri.parse(url),
        headers: headers,
        query: queryParameters,
      );
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'GET',
        uri: Uri.parse(url),
        data: response.data,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'GET',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic POST request
  Future<Response> post(
    String url, {
    dynamic data,
    bool requiresAuth = true,
    String? token,
  }) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      AppLogger.apiRequest(
        method: 'POST',
        uri: Uri.parse(url),
        headers: headers,
        body: data,
      );
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'POST',
        uri: Uri.parse(url),
        data: response.data,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'POST',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(
    String url, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
    String? token,
  }) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      AppLogger.apiRequest(
        method: 'PUT',
        uri: Uri.parse(url),
        headers: headers,
        body: data,
      );
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'PUT',
        uri: Uri.parse(url),
        data: response.data,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'PUT',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? data,
    bool requiresAuth = true,
    String? token,
  }) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      final response = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print(
        "DELETE Request to $url succeeded with response: \${response.data}",
      );
      return response;
    } on DioException catch (e) {
      print("DELETE Request to $url failed with error: \${e.message}");
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Build headers
  Future<Map<String, String>> _buildHeaders(
    bool requiresAuth, {
    String? token,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (requiresAuth) {
      String? finalToken =
          token ?? (await SharedPreferencesHelper.getUserModel())?.token;

      if (finalToken == null || finalToken.isEmpty) {
        AppLogger.log("❌ No token found in SharedPreferences!");
      } else {
        headers['Authorization'] = 'Bearer $finalToken';
      }
    }

    return headers;
  }
}

class ApiDeviceService {
  static String baseUrl =
      dotenv.env["PROD_ENDPOINT_AUTH"] ?? "https://your-backend.url/api";

  static Future<void> sendDeviceInfo(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/device/register");

    try {
      AppLogger.apiRequest(
        method: 'POST',
        uri: url,
        headers: {'Content-Type': 'application/json'},
        body: data,
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'POST',
        uri: url,
        data: response.body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.log(
          "📡 Device info sent successfully: ${response.statusCode}",
        );
      } else {
        AppLogger.log(
          "⚠️ Device info sent with status: ${response.statusCode}",
        );
      }
    } on http.ClientException catch (e) {
      AppLogger.apiError(
        type: 'ClientException',
        method: 'POST',
        uri: url,
        statusCode: null,
        data: e.message,
      );
      AppLogger.log("❌ Failed to send device info - Network error: $e");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      AppLogger.apiError(
        type: 'Exception',
        method: 'POST',
        uri: url,
        statusCode: null,
        data: e.toString(),
      );
      AppLogger.log("❌ Failed to send device info: $e");
      throw Exception("Failed to send device info: $e");
    }
  }
}

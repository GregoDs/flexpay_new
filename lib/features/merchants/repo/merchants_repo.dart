import 'dart:convert';

import 'package:flexpay/features/merchants/models/merchants_model.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

class MerchantsRepository {
  final ApiService _apiService = ApiService();

  Future<List<Merchant>> fetchMerchants() async {
    try {
      final url = "${ApiService.prodEndpointAuth}/merchant-list";

      final response = await _apiService.post(url);

      // Parse response into model
      final allMerchantsResponse = AllMerchantsResponse.fromJson(response.data);

      if (allMerchantsResponse.data == null ||
          allMerchantsResponse.data!.data == null) {
        AppLogger.log("❌ No merchants found in response.");
        return [];
      }

      final merchants = allMerchantsResponse.data!.data!;

      // ✅ Pretty-print merchants as JSON
      final prettyJson = const JsonEncoder.withIndent('  ')
          .convert(merchants.map((m) => m.toJson()).toList());

      AppLogger.log("📦 Parsed Merchants Response:\n$prettyJson");

      return merchants;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchMerchants: $message");
      throw Exception(message);
    }
  }
}
import 'package:flexpay/features/bookings/models/booking_payment_model/bk_payment_model.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/models/cancel_booking_model/cancel_booking_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

class BookingsRepository {
  final ApiService _apiService = ApiService();

  /// Fetch all bookings for a given user
  Future<List<Booking>> fetchAllBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/customer/$userId";

      final response = await _apiService.post(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  //Fetch active bookings
  Future<List<Booking>> fetchActiveBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/active/customer/$userId";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  /// FETCH OVERDUE BOOKINGS ///
  Future<List<Booking>> fetchOverdueBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/overdue/customer/$userId";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  /// FETCH Unserviced BOOKINGS ///
  Future<List<Booking>> fetchUnservicedBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;
      final phoneNumber = userModel?.user.phoneNumber;

      AppLogger.log("📦 PhoneNumber: ${phoneNumber}}");

      if (userId == null && phoneNumber == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url =
          "${ApiService.prodEndpointBookings}/unserviced_bookings?search_filter=254746029036";
      final response = await _apiService.post(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }


      //Fetch Completed bookings
      Future<List<Booking>> fetchCompletedBookings() async {
        try {
          // Get user token (authorization handled inside ApiService)
          final userModel = await SharedPreferencesHelper.getUserModel();
          final userId = userModel?.user.id;

          if (userId == null) {
            throw Exception("User ID not found in SharedPreferences");
          }

          final token = userModel?.token;

          final url = "${ApiService.prodEndpointBookings}/complete/customer/$userId";

          final response = await _apiService.get(
            url,
            requiresAuth: true,
            token: token,
          );

          // The API wraps data inside a "data" field
          final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

          // If wrapper/data/pBooking is missing, return empty list
          if (allBookingsResponse.data?.pBooking == null) {
            AppLogger.log("❌ No bookings found in response.");
            return [];
          }

          // Extract the list of Booking objects directly
          final bookingsJson = allBookingsResponse.data!.pBooking!;

          AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
          return bookingsJson;
        } catch (e) {
          // Use ErrorHandler to format the message properly
          final message = ErrorHandler.handleGenericError(e);
          AppLogger.log("❌ Error in fetchAllBookings: $message");
          throw Exception(message);
        }
      }





      /// Fetch a single booking by reference
    Future<Booking?> fetchBookingByReference(String bookingReference) async {
      try {
        final userModel = await SharedPreferencesHelper.getUserModel();
        final url = "${ApiService.prodEndpointBookings}/reference/$bookingReference";

        final response = await _apiService.get(
          url,
          requiresAuth: true,
        );

        // Parse entire response into model
        final bookingsResponse = AllBookingsResponse.fromJson(response.data);

        // Drill down safely into data.pBooking
        final bookings = bookingsResponse.data?.pBooking ?? [];

        if (bookings.isNotEmpty) {
          return bookings.first; // Return first booking (API is by reference, so it should be unique)
        }

        return null; // No booking found
      } catch (e) {
        final message = ErrorHandler.handleGenericError(e);
        AppLogger.log("❌ Error in fetchBookingByReference: $message");
        throw Exception(message);
      }
    }



//Cancel a booking
  Future<CancelBookingResponse> cancelBooking(String bookingReference) async {
    try {
      // Ensure bookingReference is not null
      if (bookingReference.isEmpty) {
        throw Exception("Booking reference cannot be empty");
      }

      final url = "${ApiService.prodEndpointBookings}/cancel/$bookingReference";

      final response = await _apiService.post(url, requiresAuth: true);

      final cancelResponse = CancelBookingResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      AppLogger.log("📦 Cancel booking response: ${cancelResponse.toJson()}");

      return cancelResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in cancelBooking: $message");
      throw Exception(message);
    }
  }






 // Pay a booking from wallet
  Future<BkWalletPaymentResponse> payBookingFromWallet(
    String bookingReference,
    double debitAmount,
  ) async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (bookingReference.isEmpty) {
        throw Exception("Booking reference cannot be empty");
      }

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final url = "${ApiService.prodEndpointWallet}/wallet/debit";

      final body = {
        "userId": userId,
        "booking_reference": bookingReference,
        "debitAmount": debitAmount,
      };

      // ✅ Make the POST request with the body
      final response = await _apiService.post(
        url,
        requiresAuth: true,
        data: body,
      );

      // ✅ Parse response into model
      final bkWalletPaymentResponse = BkWalletPaymentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      AppLogger.log(
        "📦 Wallet payment response: ${bkWalletPaymentResponse.toJson()}",
      );

      // ✅ Return parsed response
      return bkWalletPaymentResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in making wallet payment: $message");
      throw Exception(message);
    }
  }


//PAY FOR BOOKING VIA MPESA
Future<BkMpesaPaymentResponse> payBookingViaMpesa(
    String bookingReference,
    double amount,
    String phoneNumber,
  ) async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (bookingReference.isEmpty) {
        throw Exception("Booking reference cannot be empty");
      }

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final url = "${ApiService.prodEndpointPayments}/stk_request";

      final body = {
        "user_id": userId,
        "reference": bookingReference,
        "amount": amount,
        "phone": phoneNumber,
        "description": "Booking payment",
        };

      // ✅ Make the POST request with the body
      final response = await _apiService.post(
        url,
        requiresAuth: true,
        data: body,
      );

      // ✅ Parse response into model
      final bkMpesaPaymentResponse = BkMpesaPaymentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      AppLogger.log(
        "📦 Mpesa payment response: ${bkMpesaPaymentResponse.toJson()}",
      );

      // ✅ Return parsed response
      return bkMpesaPaymentResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in making mpesa payment: $message");
      throw Exception(message);
    }
  }
}

import 'package:flexpay/features/bookings/cubit/bookings_state.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/repo/bookings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingsRepository _repository;

  BookingsCubit(this._repository) : super(BookingsInitial());

  Future<void> fetchBookingsByType(String type) async {
    emit(BookingsLoading());

    try {
      final bookings = switch (type.toLowerCase()) {
        // 'all'       => await _repository.fetchAllBookings(),
        'active' => await _repository.fetchActiveBookings(),
        'overdue' => await _repository.fetchOverdueBookings(),
        'unserviced' => await _repository.fetchUnservicedBookings(),
        'complete' => await _repository.fetchCompletedBookings(),
        _ => <Booking>[],
      };

      emit(BookingsFetched(bookings: bookings, bookingType: type));
    } catch (e) {
      emit(BookingsError('Failed to load $type bookings. ${e.toString()}'));
    }
  }

  /// Fetch a single booking by reference
  Future<void> fetchBookingByReference(String bookingReference) async {
    emit(BookingsLoading());
    try {
      final booking = await _repository.fetchBookingByReference(bookingReference);
      if (booking != null) {
        emit(BookingsFetched(bookings: [booking], bookingType: 'single'));
      } else {
        emit(BookingsError('Booking not found.'));
      }
    } catch (e) {
      emit(BookingsError('Failed to load booking. ${e.toString()}'));
    }
  }


  ///  → Cancel booking flow
  Future<void> cancelBooking(String bookingReference) async {
    emit(BookingCancelLoading());
    try {
      final response = await _repository.cancelBooking(bookingReference);
      emit(BookingCancelSuccess(response));
    } catch (e) {
      emit(BookingCancelError('Failed to cancel booking. ${e.toString()}'));
    }
  }

  /// Wallet payment flow
  Future<void> payBookingFromWallet(
    String bookingReference,
    double debitAmount,
  ) async {
    emit(BookingWalletPaymentLoading());
    try {
      final response = await _repository.payBookingFromWallet(
        bookingReference,
        debitAmount,
      );
      emit(BookingWalletPaymentSuccess(response));
    } catch (e) {
      emit(
        BookingWalletPaymentError(
          'Failed to pay booking from wallet. ${e.toString()}',
        ),
      );
    }
  }

  /// Mpesa payment flow
Future<void> payBookingViaMpesa(
  String bookingReference,
  double amount,
  String phoneNumber,
) async {
  emit(BookingMpesaPaymentLoading());
  try {
    final response = await _repository.payBookingViaMpesa(
      bookingReference,
      amount,
      phoneNumber,
    );
    emit(BookingMpesaPaymentSuccess(response));
  } catch (e) {
    emit(
      BookingMpesaPaymentError(
        'Failed to pay booking via Mpesa. ${e.toString()}',
      ),
    );
  }
}

}

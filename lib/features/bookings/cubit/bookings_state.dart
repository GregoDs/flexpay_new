import 'package:equatable/equatable.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/models/cancel_booking_model/cancel_booking_model.dart';
import 'package:flexpay/features/bookings/models/booking_payment_model/bk_payment_model.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsFetched extends BookingsState {
  final List<Booking> bookings;
  final String bookingType;

  const BookingsFetched({
    required this.bookings,
    required this.bookingType,
  });

  @override
  List<Object?> get props => [bookings, bookingType];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cancel states //
class BookingCancelLoading extends BookingsState {}

class BookingCancelSuccess extends BookingsState {
  final CancelBookingResponse response;

  const BookingCancelSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class BookingCancelError extends BookingsState {
  final String message;

  const BookingCancelError(this.message);

  @override
  List<Object?> get props => [message];
}

// Wallet Payment states //
class BookingWalletPaymentLoading extends BookingsState {}

class BookingWalletPaymentSuccess extends BookingsState {
  final BkWalletPaymentResponse response;

  const BookingWalletPaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class BookingWalletPaymentError extends BookingsState {
  final String message;

  const BookingWalletPaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Mpesa Payment states //
class BookingMpesaPaymentLoading extends BookingsState {}

class BookingMpesaPaymentSuccess extends BookingsState {
  final BkMpesaPaymentResponse response;

  const BookingMpesaPaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class BookingMpesaPaymentError extends BookingsState {
  final String message;

  const BookingMpesaPaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
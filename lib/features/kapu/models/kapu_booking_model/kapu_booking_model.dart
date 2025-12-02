import 'package:json_annotation/json_annotation.dart';

part 'kapu_booking_model.g.dart';

/// ---------------------- KAPU BOOKING RESPONSE ---------------------- ///
@JsonSerializable(explicitToJson: true)
class KapuBookingResponse {
  final BookingData? data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  KapuBookingResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory KapuBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$KapuBookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KapuBookingResponseToJson(this);
}

/// ---------------------- BOOKING DATA ---------------------- ///
@JsonSerializable(explicitToJson: true)
class BookingData {
  final int? id;

  @JsonKey(name: 'product_id', fromJson: _intToNullable)
  final int? productId;

  @JsonKey(name: 'user_id', fromJson: _intToString)
  final String? userId;

  @JsonKey(name: 'merchant_id', fromJson: _intToString)
  final String? merchantId;

  @JsonKey(name: 'promoter_id', fromJson: _intToNullable)
  final int? promoterId;

  @JsonKey(name: 'booking_on_credit', fromJson: _intToNullable)
  final int? bookingOnCredit;

  @JsonKey(name: 'outlet_id', fromJson: _intToNullable)
  final int? outletId;

  @JsonKey(name: 'booking_price', fromJson: _numToDouble)
  final double? bookingPrice;

  @JsonKey(name: 'booking_offer_price', fromJson: _numToDouble)
  final double? bookingOfferPrice;

  @JsonKey(name: 'initial_deposit', fromJson: _numToDouble)
  final double? initialDeposit;

  @JsonKey(name: 'is_permanent', fromJson: _intToBool)
  final bool? isPermanent;

  @JsonKey(name: 'referral_coupon')
  final String? referralCoupon;

  @JsonKey(name: 'booking_source')
  final String? bookingSource;

  @JsonKey(name: 'deadline_date')
  final String? deadlineDate;

  @JsonKey(name: 'booking_reference')
  final String? bookingReference;

  final String? frequency;

  @JsonKey(name: 'frequency_contribution')
  final dynamic frequencyContribution;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  final UserData? user;

  @JsonKey(name: 'booking_interest')
  final List<dynamic>? bookingInterest;

  @JsonKey(name: 'interest_amount', fromJson: _numToDouble)
  final double? interestAmount;

  @JsonKey(name: 'maturity_date')
  final String? maturityDate;

  @JsonKey(name: 'target_saving', fromJson: _numToDouble)
  final double? targetSaving;

  @JsonKey(name: 'chama_description')
  final String? chamaDescription;

  final String? image;

  @JsonKey(fromJson: _numToDouble)
  final double? progress;

  final List<dynamic>? payment;

  BookingData({
    this.id,
    this.productId,
    this.userId,
    this.merchantId,
    this.promoterId,
    this.bookingOnCredit,
    this.outletId,
    this.bookingPrice,
    this.bookingOfferPrice,
    this.initialDeposit,
    this.isPermanent,
    this.referralCoupon,
    this.bookingSource,
    this.deadlineDate,
    this.bookingReference,
    this.frequency,
    this.frequencyContribution,
    this.updatedAt,
    this.createdAt,
    this.user,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
    this.payment,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDataToJson(this);

  /// ------------------ UTILITY FUNCTIONS FOR SAFE TYPE CAST ------------------ ///
  static String? _intToString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static int? _intToNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _numToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool? _intToBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1';
    return null;
  }
}

/// ---------------------- USER DATA ---------------------- ///
@JsonSerializable()
class UserData {
  final int? id;

  @JsonKey(name: 'user_id', fromJson: _intToNullable)
  final int? userId;

  @JsonKey(name: 'referral_id', fromJson: _intToNullable)
  final int? referralId;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'phone_number_1')
  final String? phoneNumber1;

  @JsonKey(name: 'id_number')
  final String? idNumber;

  @JsonKey(name: 'passport_number')
  final String? passportNumber;

  final String? dob;
  final String? country;

  UserData({
    this.id,
    this.userId,
    this.referralId,
    this.firstName,
    this.lastName,
    this.phoneNumber1,
    this.idNumber,
    this.passportNumber,
    this.dob,
    this.country,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  static int? _intToNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
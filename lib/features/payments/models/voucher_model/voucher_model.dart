import 'package:json_annotation/json_annotation.dart';

part 'voucher_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VoucherResponse {
  final dynamic data; // Can be VoucherData (object) or List
  final List<dynamic>? errors; // Can be List<String> or List<Map<String, dynamic>>
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  VoucherResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) =>
      _$VoucherResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VoucherData {
  @JsonKey(name: 'product_id')
  final int? productId;

  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'country_id')
  final int? countryId;

  @JsonKey(name: 'merchant_id')
  final String? merchantId;

  @JsonKey(name: 'promoter_id')
  final int? promoterId;

  @JsonKey(name: 'outlet_id')
  final int? outletId;

  @JsonKey(name: 'booking_price')
  final String? bookingPrice;

  @JsonKey(name: 'booking_source')
  final String? bookingSource;

  @JsonKey(name: 'booking_offer_price')
  final String? bookingOfferPrice;

  @JsonKey(name: 'initial_deposit')
  final String? initialDeposit;

  @JsonKey(name: 'deadline_date')
  final String? deadlineDate;

  @JsonKey(name: 'booking_reference')
  final String? bookingReference;

  @JsonKey(name: 'referral_coupon')
  final String? referralCoupon;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  final int? id;

  @JsonKey(name: 'booking_interest')
  final List<dynamic>? bookingInterest;

  @JsonKey(name: 'interest_amount')
  final int? interestAmount;

  @JsonKey(name: 'maturity_date')
  final String? maturityDate;

  @JsonKey(name: 'target_saving')
  final String? targetSaving;

  @JsonKey(name: 'chama_description')
  final String? chamaDescription;

  final String? image;

  final int? progress;

  final List<Payment>? payment;

  VoucherData({
    this.productId,
    this.userId,
    this.countryId,
    this.merchantId,
    this.promoterId,
    this.outletId,
    this.bookingPrice,
    this.bookingSource,
    this.bookingOfferPrice,
    this.initialDeposit,
    this.deadlineDate,
    this.bookingReference,
    this.referralCoupon,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
    this.payment,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) =>
      _$VoucherDataFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDataToJson(this);
}

@JsonSerializable()
class Payment {
  final int? id;

  @JsonKey(name: 'payment_id')
  final int? paymentId;

  @JsonKey(name: 'booking_id')
  final int? bookingId;

  @JsonKey(name: 'wallet_id')
  final int? walletId;

  @JsonKey(name: 'payment_amount')
  final dynamic paymentAmount; // can be int or string

  final String? destination;

  @JsonKey(name: 'destination_account_no')
  final String? destinationAccountNo;

  @JsonKey(name: 'destination_phone_no')
  final String? destinationPhoneNo;

  @JsonKey(name: 'destination_transaction_reference')
  final String? destinationTransactionReference;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Payment({
    this.id,
    this.paymentId,
    this.bookingId,
    this.walletId,
    this.paymentAmount,
    this.destination,
    this.destinationAccountNo,
    this.destinationPhoneNo,
    this.destinationTransactionReference,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
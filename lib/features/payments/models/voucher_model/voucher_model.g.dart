// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherResponse _$VoucherResponseFromJson(Map<String, dynamic> json) =>
    VoucherResponse(
      data: json['data'],
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$VoucherResponseToJson(VoucherResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

VoucherData _$VoucherDataFromJson(Map<String, dynamic> json) => VoucherData(
  productId: (json['product_id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  countryId: (json['country_id'] as num?)?.toInt(),
  merchantId: json['merchant_id'] as String?,
  promoterId: (json['promoter_id'] as num?)?.toInt(),
  outletId: (json['outlet_id'] as num?)?.toInt(),
  bookingPrice: json['booking_price'] as String?,
  bookingSource: json['booking_source'] as String?,
  bookingOfferPrice: json['booking_offer_price'] as String?,
  initialDeposit: json['initial_deposit'] as String?,
  deadlineDate: json['deadline_date'] as String?,
  bookingReference: json['booking_reference'] as String?,
  referralCoupon: json['referral_coupon'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  id: (json['id'] as num?)?.toInt(),
  bookingInterest: json['booking_interest'] as List<dynamic>?,
  interestAmount: (json['interest_amount'] as num?)?.toInt(),
  maturityDate: json['maturity_date'] as String?,
  targetSaving: json['target_saving'] as String?,
  chamaDescription: json['chama_description'] as String?,
  image: json['image'] as String?,
  progress: (json['progress'] as num?)?.toInt(),
  payment: (json['payment'] as List<dynamic>?)
      ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VoucherDataToJson(VoucherData instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'user_id': instance.userId,
      'country_id': instance.countryId,
      'merchant_id': instance.merchantId,
      'promoter_id': instance.promoterId,
      'outlet_id': instance.outletId,
      'booking_price': instance.bookingPrice,
      'booking_source': instance.bookingSource,
      'booking_offer_price': instance.bookingOfferPrice,
      'initial_deposit': instance.initialDeposit,
      'deadline_date': instance.deadlineDate,
      'booking_reference': instance.bookingReference,
      'referral_coupon': instance.referralCoupon,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'id': instance.id,
      'booking_interest': instance.bookingInterest,
      'interest_amount': instance.interestAmount,
      'maturity_date': instance.maturityDate,
      'target_saving': instance.targetSaving,
      'chama_description': instance.chamaDescription,
      'image': instance.image,
      'progress': instance.progress,
      'payment': instance.payment?.map((e) => e.toJson()).toList(),
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num?)?.toInt(),
  paymentId: (json['payment_id'] as num?)?.toInt(),
  bookingId: (json['booking_id'] as num?)?.toInt(),
  walletId: (json['wallet_id'] as num?)?.toInt(),
  paymentAmount: json['payment_amount'],
  destination: json['destination'] as String?,
  destinationAccountNo: json['destination_account_no'] as String?,
  destinationPhoneNo: json['destination_phone_no'] as String?,
  destinationTransactionReference:
      json['destination_transaction_reference'] as String?,
  deletedAt: json['deleted_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'payment_id': instance.paymentId,
  'booking_id': instance.bookingId,
  'wallet_id': instance.walletId,
  'payment_amount': instance.paymentAmount,
  'destination': instance.destination,
  'destination_account_no': instance.destinationAccountNo,
  'destination_phone_no': instance.destinationPhoneNo,
  'destination_transaction_reference': instance.destinationTransactionReference,
  'deleted_at': instance.deletedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

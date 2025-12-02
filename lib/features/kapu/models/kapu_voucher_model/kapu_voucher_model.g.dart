// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateVoucherResponse _$CreateVoucherResponseFromJson(
  Map<String, dynamic> json,
) => CreateVoucherResponse(
  data: json['data'] == null
      ? null
      : VoucherData.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as List<dynamic>?,
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$CreateVoucherResponseToJson(
  CreateVoucherResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

VoucherData _$VoucherDataFromJson(Map<String, dynamic> json) => VoucherData(
  data: json['data'],
  errors: json['errors'] as List<dynamic>?,
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$VoucherDataToJson(VoucherData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

VoucherDetails _$VoucherDetailsFromJson(Map<String, dynamic> json) =>
    VoucherDetails(
      id: (json['id'] as num?)?.toInt(),
      countryId: (json['country_id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      bookingSource: json['booking_source'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      merchantId: (json['merchant_id'] as num?)?.toInt(),
      promoterId: (json['promoter_id'] as num?)?.toInt(),
      outletId: (json['outlet_id'] as num?)?.toInt(),
      bookingReference: json['booking_reference'] as String?,
      referralCoupon: json['referral_coupon'] as String?,
      bookingPrice: json['booking_price'] as num?,
      validationPrice: json['validation_price'] as num?,
      bookingOfferPrice: json['booking_offer_price'] as num?,
      initialDeposit: json['initial_deposit'] as num?,
      hasFixedDeadline: json['has_fixed_deadline'] as String?,
      bookingStatus: json['booking_status'] as String?,
      isPermanent: (json['is_permanent'] as num?)?.toInt(),
      parentBookingId: (json['parent_booking_id'] as num?)?.toInt(),
      isPromotional: (json['is_promotional'] as num?)?.toInt(),
      promotionalAmount: json['promotional_amount'] as num?,
      endDate: json['end_date'] as String?,
      deadlineDate: json['deadline_date'] as String?,
      bookingOnCredit: (json['booking_on_credit'] as num?)?.toInt(),
      accountName: json['account_name'] as String?,
      accountNo: json['account_no'] as String?,
      reference: json['reference'] as String?,
      phoneNumber: json['phone_number'] as String?,
      checkoutStatus: json['checkout_status'] as String?,
      frequency: json['frequency'] as String?,
      frequencyContribution: json['frequency_contribution'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      bookingInterest: json['booking_interest'] as List<dynamic>?,
      interestAmount: json['interest_amount'] as num?,
      maturityDate: json['maturity_date'] as String?,
      targetSaving: json['target_saving'] as num?,
      chamaDescription: json['chama_description'] as String?,
      image: json['image'] as String?,
      progress: json['progress'] as num?,
    );

Map<String, dynamic> _$VoucherDetailsToJson(VoucherDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country_id': instance.countryId,
      'product_id': instance.productId,
      'booking_source': instance.bookingSource,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'promoter_id': instance.promoterId,
      'outlet_id': instance.outletId,
      'booking_reference': instance.bookingReference,
      'referral_coupon': instance.referralCoupon,
      'booking_price': instance.bookingPrice,
      'validation_price': instance.validationPrice,
      'booking_offer_price': instance.bookingOfferPrice,
      'initial_deposit': instance.initialDeposit,
      'has_fixed_deadline': instance.hasFixedDeadline,
      'booking_status': instance.bookingStatus,
      'is_permanent': instance.isPermanent,
      'parent_booking_id': instance.parentBookingId,
      'is_promotional': instance.isPromotional,
      'promotional_amount': instance.promotionalAmount,
      'end_date': instance.endDate,
      'deadline_date': instance.deadlineDate,
      'booking_on_credit': instance.bookingOnCredit,
      'account_name': instance.accountName,
      'account_no': instance.accountNo,
      'reference': instance.reference,
      'phone_number': instance.phoneNumber,
      'checkout_status': instance.checkoutStatus,
      'frequency': instance.frequency,
      'frequency_contribution': instance.frequencyContribution,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'booking_interest': instance.bookingInterest,
      'interest_amount': instance.interestAmount,
      'maturity_date': instance.maturityDate,
      'target_saving': instance.targetSaving,
      'chama_description': instance.chamaDescription,
      'image': instance.image,
      'progress': instance.progress,
    };

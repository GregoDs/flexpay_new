// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KapuBookingResponse _$KapuBookingResponseFromJson(Map<String, dynamic> json) =>
    KapuBookingResponse(
      data: json['data'] == null
          ? null
          : BookingData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$KapuBookingResponseToJson(
  KapuBookingResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

BookingData _$BookingDataFromJson(Map<String, dynamic> json) => BookingData(
  id: (json['id'] as num?)?.toInt(),
  productId: BookingData._intToNullable(json['product_id']),
  userId: BookingData._intToString(json['user_id']),
  merchantId: BookingData._intToString(json['merchant_id']),
  promoterId: BookingData._intToNullable(json['promoter_id']),
  bookingOnCredit: BookingData._intToNullable(json['booking_on_credit']),
  outletId: BookingData._intToNullable(json['outlet_id']),
  bookingPrice: BookingData._numToDouble(json['booking_price']),
  bookingOfferPrice: BookingData._numToDouble(json['booking_offer_price']),
  initialDeposit: BookingData._numToDouble(json['initial_deposit']),
  isPermanent: BookingData._intToBool(json['is_permanent']),
  referralCoupon: json['referral_coupon'] as String?,
  bookingSource: json['booking_source'] as String?,
  deadlineDate: json['deadline_date'] as String?,
  bookingReference: json['booking_reference'] as String?,
  frequency: json['frequency'] as String?,
  frequencyContribution: json['frequency_contribution'],
  updatedAt: json['updated_at'] as String?,
  createdAt: json['created_at'] as String?,
  user: json['user'] == null
      ? null
      : UserData.fromJson(json['user'] as Map<String, dynamic>),
  bookingInterest: json['booking_interest'] as List<dynamic>?,
  interestAmount: BookingData._numToDouble(json['interest_amount']),
  maturityDate: json['maturity_date'] as String?,
  targetSaving: BookingData._numToDouble(json['target_saving']),
  chamaDescription: json['chama_description'] as String?,
  image: json['image'] as String?,
  progress: BookingData._numToDouble(json['progress']),
  payment: json['payment'] as List<dynamic>?,
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'promoter_id': instance.promoterId,
      'booking_on_credit': instance.bookingOnCredit,
      'outlet_id': instance.outletId,
      'booking_price': instance.bookingPrice,
      'booking_offer_price': instance.bookingOfferPrice,
      'initial_deposit': instance.initialDeposit,
      'is_permanent': instance.isPermanent,
      'referral_coupon': instance.referralCoupon,
      'booking_source': instance.bookingSource,
      'deadline_date': instance.deadlineDate,
      'booking_reference': instance.bookingReference,
      'frequency': instance.frequency,
      'frequency_contribution': instance.frequencyContribution,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'user': instance.user?.toJson(),
      'booking_interest': instance.bookingInterest,
      'interest_amount': instance.interestAmount,
      'maturity_date': instance.maturityDate,
      'target_saving': instance.targetSaving,
      'chama_description': instance.chamaDescription,
      'image': instance.image,
      'progress': instance.progress,
      'payment': instance.payment,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: (json['id'] as num?)?.toInt(),
  userId: UserData._intToNullable(json['user_id']),
  referralId: UserData._intToNullable(json['referral_id']),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phoneNumber1: json['phone_number_1'] as String?,
  idNumber: json['id_number'] as String?,
  passportNumber: json['passport_number'] as String?,
  dob: json['dob'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'referral_id': instance.referralId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number_1': instance.phoneNumber1,
  'id_number': instance.idNumber,
  'passport_number': instance.passportNumber,
  'dob': instance.dob,
  'country': instance.country,
};

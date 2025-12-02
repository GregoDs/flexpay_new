// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_goal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoalResponse _$CreateGoalResponseFromJson(Map<String, dynamic> json) =>
    CreateGoalResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookingWrapper.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateGoalResponseToJson(CreateGoalResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

BookingWrapper _$BookingWrapperFromJson(Map<String, dynamic> json) =>
    BookingWrapper(
      booking: json['booking'] == null
          ? null
          : BookingData.fromJson(json['booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingWrapperToJson(BookingWrapper instance) =>
    <String, dynamic>{'booking': instance.booking?.toJson()};

BookingData _$BookingDataFromJson(Map<String, dynamic> json) => BookingData(
  data: json['data'] == null
      ? null
      : BookingDetails.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as List<dynamic>?,
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

BookingDetails _$BookingDetailsFromJson(Map<String, dynamic> json) =>
    BookingDetails(
      productId: json['product_id'] as String?,
      userId: json['user_id'] as String?,
      merchantId: json['merchant_id'] as String?,
      bookingPrice: json['booking_price'] as String?,
      initialDeposit: json['initial_deposit'] as String?,
      deadlineDate: json['deadline_date'] as String?,
      bookingReference: json['booking_reference'] as String?,
      frequency: json['frequency'] as String?,
      frequencyContribution: json['frequency_contribution'] as String?,
      targetSaving: json['target_saving'] as String?,
      maturityDate: json['maturity_date'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingDetailsToJson(BookingDetails instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'booking_price': instance.bookingPrice,
      'initial_deposit': instance.initialDeposit,
      'deadline_date': instance.deadlineDate,
      'booking_reference': instance.bookingReference,
      'frequency': instance.frequency,
      'frequency_contribution': instance.frequencyContribution,
      'target_saving': instance.targetSaving,
      'maturity_date': instance.maturityDate,
      'progress': instance.progress,
      'user': instance.user?.toJson(),
      'customer': instance.customer?.toJson(),
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  first_name: json['first_name'] as String?,
  last_name: json['last_name'] as String?,
  phone_number_1: json['phone_number_1'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'first_name': instance.first_name,
  'last_name': instance.last_name,
  'phone_number_1': instance.phone_number_1,
  'country': instance.country,
};

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  first_name: json['first_name'] as String?,
  last_name: json['last_name'] as String?,
  phone_number_1: json['phone_number_1'] as String?,
  gender: json['gender'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'first_name': instance.first_name,
  'last_name': instance.last_name,
  'phone_number_1': instance.phone_number_1,
  'gender': instance.gender,
  'country': instance.country,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_goals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchGoalsResponse _$FetchGoalsResponseFromJson(Map<String, dynamic> json) =>
    FetchGoalsResponse(
      data: json['data'] == null
          ? null
          : FetchGoalsData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FetchGoalsResponseToJson(FetchGoalsResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

FetchGoalsData _$FetchGoalsDataFromJson(Map<String, dynamic> json) =>
    FetchGoalsData(
      goals: json['goals'] == null
          ? null
          : GoalsPagination.fromJson(json['goals'] as Map<String, dynamic>),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((e) => PaymentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FetchGoalsDataToJson(FetchGoalsData instance) =>
    <String, dynamic>{
      'goals': instance.goals?.toJson(),
      'payments': instance.payments?.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };

GoalsPagination _$GoalsPaginationFromJson(Map<String, dynamic> json) =>
    GoalsPagination(
      currentPage: (json['current_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GoalData.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String?,
      from: (json['from'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      lastPageUrl: json['last_page_url'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String?,
      perPage: (json['per_page'] as num?)?.toInt(),
      prevPageUrl: json['prev_page_url'] as String?,
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GoalsPaginationToJson(GoalsPagination instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'first_page_url': instance.firstPageUrl,
      'from': instance.from,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'links': instance.links?.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
      'path': instance.path,
      'per_page': instance.perPage,
      'prev_page_url': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };

PaginationLink _$PaginationLinkFromJson(Map<String, dynamic> json) =>
    PaginationLink(
      url: json['url'] as String?,
      label: json['label'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$PaginationLinkToJson(PaginationLink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };

GoalData _$GoalDataFromJson(Map<String, dynamic> json) => GoalData(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  merchantId: (json['merchant_id'] as num?)?.toInt(),
  productName: json['product_name'] as String?,
  productCode: json['product_code'] as String?,
  bookingReference: json['booking_reference'] as String?,
  bookingPrice: json['booking_price'],
  initialDeposit: json['initial_deposit'],
  bookingStatus: json['booking_status'] as String?,
  merchantName: json['merchant_name'] as String?,
  productCategoryName: json['product_category_name'] as String?,
  productTypeName: json['product_type_name'] as String?,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  total: json['total'],
);

Map<String, dynamic> _$GoalDataToJson(GoalData instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'merchant_id': instance.merchantId,
  'product_name': instance.productName,
  'product_code': instance.productCode,
  'booking_reference': instance.bookingReference,
  'booking_price': instance.bookingPrice,
  'initial_deposit': instance.initialDeposit,
  'booking_status': instance.bookingStatus,
  'merchant_name': instance.merchantName,
  'product_category_name': instance.productCategoryName,
  'product_type_name': instance.productTypeName,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'total': instance.total,
};

PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) => PaymentData(
  id: (json['id'] as num?)?.toInt(),
  paymentId: (json['payment_id'] as num?)?.toInt(),
  bookingId: (json['booking_id'] as num?)?.toInt(),
  paymentAmount: json['payment_amount'],
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$PaymentDataToJson(PaymentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_id': instance.paymentId,
      'booking_id': instance.bookingId,
      'payment_amount': instance.paymentAmount,
      'created_at': instance.createdAt,
    };

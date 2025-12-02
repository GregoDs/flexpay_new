import 'package:json_annotation/json_annotation.dart';

part 'show_goals_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchGoalsResponse {
  final FetchGoalsData? data;
  final List<dynamic>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  FetchGoalsResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  /// ✅ Custom factory to handle both `data: []` and `data: {...}`
  factory FetchGoalsResponse.fromJson(Map<String, dynamic> json) {
    final dataField = json['data'];

    return FetchGoalsResponse(
      data: (dataField is Map<String, dynamic>)
          ? FetchGoalsData.fromJson(dataField)
          : null, // handles when data is [] or null
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$FetchGoalsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FetchGoalsData {
  final GoalsPagination? goals;
  final List<PaymentData>? payments;
  final int? total;

  FetchGoalsData({
    this.goals,
    this.payments,
    this.total,
  });

  factory FetchGoalsData.fromJson(Map<String, dynamic> json) =>
      _$FetchGoalsDataFromJson(json);

  Map<String, dynamic> toJson() => _$FetchGoalsDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GoalsPagination {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  final List<GoalData>? data;
  @JsonKey(name: 'first_page_url')
  final String? firstPageUrl;
  final int? from;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  @JsonKey(name: 'last_page_url')
  final String? lastPageUrl;
  final List<PaginationLink>? links;
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  final String? path;
  @JsonKey(name: 'per_page')
  final int? perPage;
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;
  final int? to;
  final int? total;

  GoalsPagination({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory GoalsPagination.fromJson(Map<String, dynamic> json) =>
      _$GoalsPaginationFromJson(json);

  Map<String, dynamic> toJson() => _$GoalsPaginationToJson(this);
}

@JsonSerializable()
class PaginationLink {
  final String? url;
  final String? label;
  final bool? active;

  PaginationLink({this.url, this.label, this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationLinkToJson(this);
}

@JsonSerializable()
class GoalData {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'merchant_id')
  final int? merchantId;
  @JsonKey(name: 'product_name')
  final String? productName;
  @JsonKey(name: 'product_code')
  final String? productCode;
  @JsonKey(name: 'booking_reference')
  final String? bookingReference;
  @JsonKey(name: 'booking_price')
  final dynamic bookingPrice;
  @JsonKey(name: 'initial_deposit')
  final dynamic initialDeposit;
  @JsonKey(name: 'booking_status')
  final String? bookingStatus;
  @JsonKey(name: 'merchant_name')
  final String? merchantName;
  @JsonKey(name: 'product_category_name')
  final String? productCategoryName;
  @JsonKey(name: 'product_type_name')
  final String? productTypeName;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final dynamic total;

  GoalData({
    this.id,
    this.userId,
    this.merchantId,
    this.productName,
    this.productCode,
    this.bookingReference,
    this.bookingPrice,
    this.initialDeposit,
    this.bookingStatus,
    this.merchantName,
    this.productCategoryName,
    this.productTypeName,
    this.startDate,
    this.endDate,
    this.total,
  });

  factory GoalData.fromJson(Map<String, dynamic> json) =>
      _$GoalDataFromJson(json);

  Map<String, dynamic> toJson() => _$GoalDataToJson(this);
}

@JsonSerializable()
class PaymentData {
  final int? id;
  @JsonKey(name: 'payment_id')
  final int? paymentId;
  @JsonKey(name: 'booking_id')
  final int? bookingId;
  @JsonKey(name: 'payment_amount')
  final dynamic paymentAmount;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  PaymentData({
    this.id,
    this.paymentId,
    this.bookingId,
    this.paymentAmount,
    this.createdAt,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDataToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'kapu_voucher_model.g.dart';

/// -------------------
/// ROOT RESPONSE MODEL
/// -------------------
@JsonSerializable(explicitToJson: true)
class CreateVoucherResponse {
  final VoucherData? data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  CreateVoucherResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory CreateVoucherResponse.fromJson(Map<String, dynamic> json) {
    return CreateVoucherResponse(
      data: (json['data'] is Map<String, dynamic>)
          ? VoucherData.fromJson(json['data'])
          : null,
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$CreateVoucherResponseToJson(this);

  /// Collects all possible error messages from root and nested data
  List<String> collectAllErrors() {
    final messages = <String>[];

    if (errors != null) {
      messages.addAll(_flattenErrors(errors!));
    }

    if (data?.errors != null && data!.errors!.isNotEmpty) {
      messages.addAll(data!.errorMessages);
    }

    return messages;
  }

  List<String> _flattenErrors(dynamic error) {
    final messages = <String>[];
    if (error == null) return messages;

    if (error is String) {
      messages.add(error);
    } else if (error is List) {
      for (final e in error) {
        messages.addAll(_flattenErrors(e));
      }
    } else if (error is Map) {
      error.forEach((key, value) {
        if (value is List) {
          messages.addAll(value.map((v) => "$key: $v"));
        } else {
          messages.add("$key: $value");
        }
      });
    }
    return messages;
  }
}

/// -------------------
/// INNER DATA WRAPPER
/// -------------------
@JsonSerializable(explicitToJson: true)
class VoucherData {
  final dynamic data;
  final List<dynamic>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  VoucherData({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) {
    final dynamic inner = json['data'];

    // Dynamically handle either a single voucher object or a list
    dynamic parsedData;
    if (inner is Map<String, dynamic> && inner.containsKey('id')) {
      parsedData = VoucherDetails.fromJson(inner);
    } else {
      parsedData = inner; // Might be [] or any raw structure
    }

    return VoucherData(
      data: parsedData,
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$VoucherDataToJson(this);

  List<String> get errorMessages {
    if (errors == null) return [];
    final messages = <String>[];

    for (final e in errors!) {
      if (e is String) {
        messages.add(e);
      } else if (e is Map<String, dynamic>) {
        e.forEach((key, value) {
          if (value is List) {
            messages.addAll(value.map((v) => "$key: $v"));
          } else {
            messages.add("$key: $value");
          }
        });
      }
    }
    return messages;
  }
}

/// -------------------
/// ACTUAL VOUCHER DATA
/// -------------------
@JsonSerializable()
class VoucherDetails {
  final int? id;
  @JsonKey(name: 'country_id')
  final int? countryId;
  @JsonKey(name: 'product_id')
  final int? productId;
  @JsonKey(name: 'booking_source')
  final String? bookingSource;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'merchant_id')
  final int? merchantId;
  @JsonKey(name: 'promoter_id')
  final int? promoterId;
  @JsonKey(name: 'outlet_id')
  final int? outletId;
  @JsonKey(name: 'booking_reference')
  final String? bookingReference;
  @JsonKey(name: 'referral_coupon')
  final String? referralCoupon;
  @JsonKey(name: 'booking_price')
  final num? bookingPrice;
  @JsonKey(name: 'validation_price')
  final num? validationPrice;
  @JsonKey(name: 'booking_offer_price')
  final num? bookingOfferPrice;
  @JsonKey(name: 'initial_deposit')
  final num? initialDeposit;
  @JsonKey(name: 'has_fixed_deadline')
  final String? hasFixedDeadline;
  @JsonKey(name: 'booking_status')
  final String? bookingStatus;
  @JsonKey(name: 'is_permanent')
  final int? isPermanent;
  @JsonKey(name: 'parent_booking_id')
  final int? parentBookingId;
  @JsonKey(name: 'is_promotional')
  final int? isPromotional;
  @JsonKey(name: 'promotional_amount')
  final num? promotionalAmount;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'deadline_date')
  final String? deadlineDate;
  @JsonKey(name: 'booking_on_credit')
  final int? bookingOnCredit;
  @JsonKey(name: 'account_name')
  final String? accountName;
  @JsonKey(name: 'account_no')
  final String? accountNo;
  final String? reference;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'checkout_status')
  final String? checkoutStatus;
  final String? frequency;
  @JsonKey(name: 'frequency_contribution')
  final String? frequencyContribution;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @JsonKey(name: 'booking_interest')
  final List<dynamic>? bookingInterest;
  @JsonKey(name: 'interest_amount')
  final num? interestAmount;
  @JsonKey(name: 'maturity_date')
  final String? maturityDate;
  @JsonKey(name: 'target_saving')
  final num? targetSaving;
  @JsonKey(name: 'chama_description')
  final String? chamaDescription;
  final String? image;
  final num? progress;

  VoucherDetails({
    this.id,
    this.countryId,
    this.productId,
    this.bookingSource,
    this.userId,
    this.merchantId,
    this.promoterId,
    this.outletId,
    this.bookingReference,
    this.referralCoupon,
    this.bookingPrice,
    this.validationPrice,
    this.bookingOfferPrice,
    this.initialDeposit,
    this.hasFixedDeadline,
    this.bookingStatus,
    this.isPermanent,
    this.parentBookingId,
    this.isPromotional,
    this.promotionalAmount,
    this.endDate,
    this.deadlineDate,
    this.bookingOnCredit,
    this.accountName,
    this.accountNo,
    this.reference,
    this.phoneNumber,
    this.checkoutStatus,
    this.frequency,
    this.frequencyContribution,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
  });

  factory VoucherDetails.fromJson(Map<String, dynamic> json) =>
      _$VoucherDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDetailsToJson(this);
}
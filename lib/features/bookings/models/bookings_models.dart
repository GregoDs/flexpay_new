/// -------------------
/// TOP LEVEL RESPONSE
/// -------------------
class AllBookingsResponse {
  final BookingData? data;
  final List<dynamic>? errors;
  final bool? success;
  final int? statusCode;

  AllBookingsResponse({this.data, this.errors, this.success, this.statusCode});

  factory AllBookingsResponse.fromJson(Map<String, dynamic> json) {
    return AllBookingsResponse(
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
      errors: json['errors'] ?? [],
      success: json['success'],
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'errors': errors,
      'success': success,
      'status_code': statusCode,
    };
  }
}

/// -------------------
/// WRAPPER → data.pBooking
/// -------------------
class BookingData {
  final List<Booking>? pBooking;

  BookingData({this.pBooking});

  factory BookingData.fromJson(dynamic json) {
    // Handle case: data is [] (empty array)
    if (json is List) {
      return BookingData(pBooking: []);
    }

    // Otherwise expect a Map with pBooking
    if (json is Map<String, dynamic>) {
      final pBookingJson = json['pBooking'];

      List<dynamic> bookingsList = [];
      if (pBookingJson is List) {
        bookingsList = pBookingJson;
      } else if (pBookingJson is Map && pBookingJson['data'] is List) {
        bookingsList = pBookingJson['data'];
      }

      return BookingData(
        pBooking: bookingsList.map((e) => Booking.fromJson(e)).toList(),
      );
    }

    // Fallback: return empty
    return BookingData(pBooking: []);
  }

  Map<String, dynamic> toJson() {
    return {
      'pBooking': {'data': pBooking?.map((e) => e.toJson()).toList()},
    };
  }
}

/// -------------------
/// BOOKING MODEL (tolerant version)
/// -------------------
class Booking {
  final int? id;
  final int? countryId;
  final int? productId;
  final String? bookingSource;
  final int? userId;
  final int? merchantId;
  final int? promoterId;
  final int? outletId;
  final String? bookingReference;
  final String? referralCoupon;
  final num? bookingPrice;
  final num? validationPrice;
  final num? bookingOfferPrice;
  final num? initialDeposit;
  final String? hasFixedDeadline;
  final String? bookingStatus;
  final int? isPermanent;
  final int? parentBookingId;
  final int? isPromotional;
  final num? promotionalAmount;
  final String? endDate;
  final String? deadlineDate;
  final int? bookingOnCredit;
  final String? accountName;
  final String? accountNo;
  final String? reference;
  final String? phoneNumber;
  final String? checkoutStatus;
  final String? frequency;
  final String? frequencyContribution;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? productName;
  final String? productCode;
  final String? productCategoryName;
  final String? productTypeName;
  final String? outletName;
  final String? merchantName;
  final num? total;
  final num? balance;
  final User? user;
  final Promoter? promoter;
  final List<dynamic>? bookingInterest;
  final num? interestAmount;
  final String? maturityDate;
  final num? targetSaving;
  final String? chamaDescription;
  final String? image;
  final num? progress;
  final List<Payment>? payments;
  final Receipt? receipt;

  Booking({
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
    this.productName,
    this.productCode,
    this.productCategoryName,
    this.productTypeName,
    this.outletName,
    this.merchantName,
    this.total,
    this.balance,
    this.user,
    this.promoter,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
    this.payments,
    this.receipt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? json['booking_id'],
      countryId: json['country_id'],
      productId: json['product_id'],
      bookingSource: json['booking_source']?.toString(),
      userId: json['user_id'] ?? json['booking_user_id'],
      merchantId: json['merchant_id'],
      promoterId: json['promoter_id'],
      outletId: json['outlet_id'],
      bookingReference: json['booking_reference']?.toString(),
      referralCoupon: json['referral_coupon']?.toString(),
      bookingPrice: json['booking_price'],
      validationPrice: json['validation_price'],
      bookingOfferPrice: json['booking_offer_price'],
      initialDeposit: json['initial_deposit'],
      hasFixedDeadline: json['has_fixed_deadline']?.toString(),
      bookingStatus: json['booking_status']?.toString(),
      isPermanent: json['is_permanent'],
      parentBookingId: json['parent_booking_id'],
      isPromotional: json['is_promotional'],
      promotionalAmount: json['promotional_amount'],
      endDate: json['end_date']?.toString(),
      deadlineDate: json['deadline_date']?.toString(),
      bookingOnCredit: json['booking_on_credit'],
      accountName: json['account_name']?.toString(),
      accountNo: json['account_no']?.toString(),
      reference: json['reference']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      checkoutStatus: json['checkout_status']?.toString(),
      frequency: json['frequency']?.toString(),
      frequencyContribution: json['frequency_contribution']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      productName: json['product_name']?.toString(),
      productCode: json['product_code']?.toString(),
      productCategoryName: json['product_category_name']?.toString(),
      productTypeName: json['product_type_name']?.toString(),
      outletName: json['outlet_name']?.toString(),
      merchantName: json['merchant_name']?.toString(),
      total: json['total'],
      balance: json['balance'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      promoter: json['promoter'] != null
          ? Promoter.fromJson(json['promoter'])
          : null,
      bookingInterest: json['booking_interest'] ?? [],
      interestAmount: json['interest_amount'],
      maturityDate: json['maturity_date']?.toString(),
      targetSaving: json['target_saving'],
      chamaDescription: json['chama_description']?.toString(),
      image: json['image']?.toString(),
      progress: json['progress'],
      payments: (json['payment'] as List? ?? json['payments'] as List? ?? [])
          .map((e) => Payment.fromJson(e))
          .toList(),
      receipt: json['receipt'] != null
          ? Receipt.fromJson(json['receipt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'product_id': productId,
      'booking_source': bookingSource,
      'user_id': userId,
      'merchant_id': merchantId,
      'promoter_id': promoterId,
      'outlet_id': outletId,
      'booking_reference': bookingReference,
      'referral_coupon': referralCoupon,
      'booking_price': bookingPrice,
      'validation_price': validationPrice,
      'booking_offer_price': bookingOfferPrice,
      'initial_deposit': initialDeposit,
      'has_fixed_deadline': hasFixedDeadline,
      'booking_status': bookingStatus,
      'is_permanent': isPermanent,
      'parent_booking_id': parentBookingId,
      'is_promotional': isPromotional,
      'promotional_amount': promotionalAmount,
      'end_date': endDate,
      'deadline_date': deadlineDate,
      'booking_on_credit': bookingOnCredit,
      'account_name': accountName,
      'account_no': accountNo,
      'reference': reference,
      'phone_number': phoneNumber,
      'checkout_status': checkoutStatus,
      'frequency': frequency,
      'frequency_contribution': frequencyContribution,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'product_name': productName,
      'product_code': productCode,
      'product_category_name': productCategoryName,
      'product_type_name': productTypeName,
      'outlet_name': outletName,
      'merchant_name': merchantName,
      'total': total,
      'balance': balance,
      'user': user?.toJson(),
      'promoter': promoter?.toJson(),
      'booking_interest': bookingInterest,
      'interest_amount': interestAmount,
      'maturity_date': maturityDate,
      'target_saving': targetSaving,
      'chama_description': chamaDescription,
      'image': image,
      'progress': progress,
      'payments': payments?.map((e) => e.toJson()).toList(),
      'receipt': receipt?.toJson(),
    };
  }
}

/// -------------------
/// USER (tolerant)
/// -------------------
class User {
  final int? id;
  final int? userId;
  final int? referralId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber1;
  final String? idNumber;
  final String? passportNumber;
  final String? dob;
  final String? country;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['user_id'],
      referralId: json['referral_id'],
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      phoneNumber1: json['phone_number_1']?.toString(),
      idNumber: json['id_number']?.toString(),
      passportNumber: json['passport_number']?.toString(),
      dob: json['dob']?.toString(),
      country: json['country']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'referral_id': referralId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number_1': phoneNumber1,
      'id_number': idNumber,
      'passport_number': passportNumber,
      'dob': dob,
      'country': country,
    };
  }
}

/// -------------------
/// PAYMENT
/// -------------------
class Payment {
  final int? id;
  final int? paymentId;
  final int? bookingId;
  final int? walletId;
  final num? paymentAmount;
  final String? destination;
  final String? destinationAccountNo;
  final String? destinationPhoneNo;
  final String? destinationTransactionReference;
  final String? deletedAt;
  final String? createdAt;
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

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      paymentId: json['payment_id'],
      bookingId: json['booking_id'],
      walletId: json['wallet_id'],
      paymentAmount: json['payment_amount'],
      destination: json['destination']?.toString(),
      destinationAccountNo: json['destination_account_no']?.toString(),
      destinationPhoneNo: json['destination_phone_no']?.toString(),
      destinationTransactionReference: json['destination_transaction_reference']
          ?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_id': paymentId,
      'booking_id': bookingId,
      'wallet_id': walletId,
      'payment_amount': paymentAmount,
      'destination': destination,
      'destination_account_no': destinationAccountNo,
      'destination_phone_no': destinationPhoneNo,
      'destination_transaction_reference': destinationTransactionReference,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

/// -------------------
/// PROMOTER
/// -------------------
class Promoter {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  Promoter({this.firstName, this.lastName, this.phoneNumber});

  factory Promoter.fromJson(Map<String, dynamic> json) {
    return Promoter(
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
    };
  }
}

/// -------------------
/// RECEIPT
/// -------------------
class Receipt {
  final int? id;
  final int? userId;
  final int? merchantId;
  final int? bookingId;
  final String? paymentRef;
  final String? receiptNo;
  final num? expectedAmount;
  final num? paidAmount;
  final String? receiptStatus;
  final int? closedBy;
  final int? revokedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? validatedAt;

  Receipt({
    this.id,
    this.userId,
    this.merchantId,
    this.bookingId,
    this.paymentRef,
    this.receiptNo,
    this.expectedAmount,
    this.paidAmount,
    this.receiptStatus,
    this.closedBy,
    this.revokedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.validatedAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      userId: json['user_id'],
      merchantId: json['merchant_id'],
      bookingId: json['booking_id'],
      paymentRef: json['payment_ref']?.toString(),
      receiptNo: json['receipt_no']?.toString(),
      expectedAmount: json['expected_amount'],
      paidAmount: json['paid_amount'],
      receiptStatus: json['receipt_status']?.toString(),
      closedBy: json['closed_by'],
      revokedBy: json['revoked_by'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      validatedAt: json['validated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'merchant_id': merchantId,
      'booking_id': bookingId,
      'payment_ref': paymentRef,
      'receipt_no': receiptNo,
      'expected_amount': expectedAmount,
      'paid_amount': paidAmount,
      'receipt_status': receiptStatus,
      'closed_by': closedBy,
      'revoked_by': revokedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'validated_at': validatedAt,
    };
  }
}

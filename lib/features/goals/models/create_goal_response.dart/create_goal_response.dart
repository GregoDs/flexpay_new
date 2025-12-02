import 'package:json_annotation/json_annotation.dart';

part 'create_goal_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateGoalResponse {
  final List<BookingWrapper>? data;
  final List<dynamic>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  CreateGoalResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory CreateGoalResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateGoalResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateGoalResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BookingWrapper {
  final BookingData? booking;

  BookingWrapper({this.booking});

  factory BookingWrapper.fromJson(Map<String, dynamic> json) =>
      _$BookingWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$BookingWrapperToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BookingData {
  final BookingDetails? data;
  final List<dynamic>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  BookingData({this.data, this.errors, this.success, this.statusCode});

  factory BookingData.fromJson(Map<String, dynamic> json) =>
      _$BookingDataFromJson(json);
  Map<String, dynamic> toJson() => _$BookingDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BookingDetails {
  @JsonKey(name: 'product_id')
  final String? productId;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'merchant_id')
  final String? merchantId;
  @JsonKey(name: 'booking_price')
  final String? bookingPrice;
  @JsonKey(name: 'initial_deposit')
  final String? initialDeposit;
  @JsonKey(name: 'deadline_date')
  final String? deadlineDate;
  @JsonKey(name: 'booking_reference')
  final String? bookingReference;
  final String? frequency;
  @JsonKey(name: 'frequency_contribution')
  final String? frequencyContribution;
  @JsonKey(name: 'target_saving')
  final String? targetSaving;
  @JsonKey(name: 'maturity_date')
  final String? maturityDate;
  final double? progress;
  final User? user;
  final Customer? customer;

  BookingDetails({
    this.productId,
    this.userId,
    this.merchantId,
    this.bookingPrice,
    this.initialDeposit,
    this.deadlineDate,
    this.bookingReference,
    this.frequency,
    this.frequencyContribution,
    this.targetSaving,
    this.maturityDate,
    this.progress,
    this.user,
    this.customer,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$BookingDetailsToJson(this);
}

@JsonSerializable()
class User {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  final String? first_name;
  final String? last_name;
  final String? phone_number_1;
  final String? country;

  User({
    this.id,
    this.userId,
    this.first_name,
    this.last_name,
    this.phone_number_1,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Customer {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  final String? first_name;
  final String? last_name;
  final String? phone_number_1;
  final String? gender;
  final String? country;

  Customer({
    this.id,
    this.userId,
    this.first_name,
    this.last_name,
    this.phone_number_1,
    this.gender,
    this.country,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
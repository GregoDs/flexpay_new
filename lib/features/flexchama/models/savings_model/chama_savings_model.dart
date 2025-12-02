import 'package:json_annotation/json_annotation.dart';

part 'chama_savings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChamaSavingsResponse {
  final ChamaSavingsData? data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  ChamaSavingsResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ChamaSavingsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChamaSavingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaSavingsResponseToJson(this);

  /// ✅ Factory for safe defaults if no savings found or any error occurs
  factory ChamaSavingsResponse.empty({
    String? errorMessage,
    int statusCode = 400,
    bool isCriticalError = false, // <--- NEW flag
  }) {
    return ChamaSavingsResponse(
      data: ChamaSavingsData(
        chamaDetails: ChamaDetails(
          targetAmount: 0,
          packageAmount: 0,
          dateStarted: "",
          maturityDate: isCriticalError ? "_" : "",
          loanLimit: 0,
          totalSavings: isCriticalError ? -1 : 0, // -1 for mapping in UI
          loanTaken: 0,
          withdrawableAmount: 0,
        ),
        payments: Payments(
          currentPage: 1,
          data: [],
          firstPageUrl: "",
          from: 0,
          lastPage: 1,
          lastPageUrl: "",
          links: [],
          path: "",
          perPage: 10,
          to: 0,
          total: 0,
        ),
      ),
      errors: errorMessage != null ? [errorMessage] : [],
      success: false,
      statusCode: statusCode,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ChamaSavingsData {
  @JsonKey(name: 'chama_details')
  final ChamaDetails chamaDetails;
  final Payments payments;

  ChamaSavingsData({
    required this.chamaDetails,
    required this.payments,
  });

  factory ChamaSavingsData.fromJson(Map<String, dynamic> json) =>
      _$ChamaSavingsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaSavingsDataToJson(this);
}

@JsonSerializable()
class ChamaDetails {
  @JsonKey(name: 'target_amount')
  final int targetAmount;
  @JsonKey(name: 'package_amount')
  final int packageAmount;
  @JsonKey(name: 'date_started')
  final String dateStarted;
  @JsonKey(name: 'maturity_date')
  final String maturityDate;
  @JsonKey(name: 'loan_limit')
  final int loanLimit;
  @JsonKey(name: 'total_savings')
  final int totalSavings;
  @JsonKey(name: 'loan_taken')
  final int loanTaken;
  @JsonKey(name: 'withdrawable_amount')
  final int withdrawableAmount;

  ChamaDetails({
    required this.targetAmount,
    required this.packageAmount,
    required this.dateStarted,
    required this.maturityDate,
    required this.loanLimit,
    required this.totalSavings,
    required this.loanTaken,
    required this.withdrawableAmount,
  });

  factory ChamaDetails.fromJson(Map<String, dynamic> json) =>
      _$ChamaDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Payments {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<PaymentData> data;
  @JsonKey(name: 'first_page_url')
  final String firstPageUrl;
  final int? from;   // <-- nullable
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'last_page_url')
  final String lastPageUrl;
  final List<Link> links;
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  final String path;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;
  final int? to;     // <-- nullable
  final int total;

  Payments({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,          // nullable
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,            // nullable
    required this.total,
  });

  factory Payments.fromJson(Map<String, dynamic> json) =>
      _$PaymentsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentsToJson(this);
}

@JsonSerializable()
class PaymentData {
  final int id;
  @JsonKey(name: 'payment_amount')
  final int paymentAmount;
  @JsonKey(name: 'payment_source')
  final String paymentSource;
  @JsonKey(name: 'payment_address')
  final String paymentAddress;
  @JsonKey(name: 'txn_id')
  final String txnId;
  @JsonKey(name: 'txn_ref')
  final String txnRef;
  @JsonKey(name: 'created_at')
  final String createdAt;

  PaymentData({
    required this.id,
    required this.paymentAmount,
    required this.paymentSource,
    required this.paymentAddress,
    required this.txnId,
    required this.txnRef,
    required this.createdAt,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDataToJson(this);
}

@JsonSerializable()
class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
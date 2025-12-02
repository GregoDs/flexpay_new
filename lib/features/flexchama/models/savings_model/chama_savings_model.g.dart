// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chama_savings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChamaSavingsResponse _$ChamaSavingsResponseFromJson(
  Map<String, dynamic> json,
) => ChamaSavingsResponse(
  data: json['data'] == null
      ? null
      : ChamaSavingsData.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as List<dynamic>?,
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$ChamaSavingsResponseToJson(
  ChamaSavingsResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

ChamaSavingsData _$ChamaSavingsDataFromJson(Map<String, dynamic> json) =>
    ChamaSavingsData(
      chamaDetails: ChamaDetails.fromJson(
        json['chama_details'] as Map<String, dynamic>,
      ),
      payments: Payments.fromJson(json['payments'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChamaSavingsDataToJson(ChamaSavingsData instance) =>
    <String, dynamic>{
      'chama_details': instance.chamaDetails.toJson(),
      'payments': instance.payments.toJson(),
    };

ChamaDetails _$ChamaDetailsFromJson(Map<String, dynamic> json) => ChamaDetails(
  targetAmount: (json['target_amount'] as num).toInt(),
  packageAmount: (json['package_amount'] as num).toInt(),
  dateStarted: json['date_started'] as String,
  maturityDate: json['maturity_date'] as String,
  loanLimit: (json['loan_limit'] as num).toInt(),
  totalSavings: (json['total_savings'] as num).toInt(),
  loanTaken: (json['loan_taken'] as num).toInt(),
  withdrawableAmount: (json['withdrawable_amount'] as num).toInt(),
);

Map<String, dynamic> _$ChamaDetailsToJson(ChamaDetails instance) =>
    <String, dynamic>{
      'target_amount': instance.targetAmount,
      'package_amount': instance.packageAmount,
      'date_started': instance.dateStarted,
      'maturity_date': instance.maturityDate,
      'loan_limit': instance.loanLimit,
      'total_savings': instance.totalSavings,
      'loan_taken': instance.loanTaken,
      'withdrawable_amount': instance.withdrawableAmount,
    };

Payments _$PaymentsFromJson(Map<String, dynamic> json) => Payments(
  currentPage: (json['current_page'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => PaymentData.fromJson(e as Map<String, dynamic>))
      .toList(),
  firstPageUrl: json['first_page_url'] as String,
  from: (json['from'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  lastPageUrl: json['last_page_url'] as String,
  links: (json['links'] as List<dynamic>)
      .map((e) => Link.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextPageUrl: json['next_page_url'] as String?,
  path: json['path'] as String,
  perPage: (json['per_page'] as num).toInt(),
  prevPageUrl: json['prev_page_url'] as String?,
  to: (json['to'] as num?)?.toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PaymentsToJson(Payments instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'first_page_url': instance.firstPageUrl,
  'from': instance.from,
  'last_page': instance.lastPage,
  'last_page_url': instance.lastPageUrl,
  'links': instance.links.map((e) => e.toJson()).toList(),
  'next_page_url': instance.nextPageUrl,
  'path': instance.path,
  'per_page': instance.perPage,
  'prev_page_url': instance.prevPageUrl,
  'to': instance.to,
  'total': instance.total,
};

PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) => PaymentData(
  id: (json['id'] as num).toInt(),
  paymentAmount: (json['payment_amount'] as num).toInt(),
  paymentSource: json['payment_source'] as String,
  paymentAddress: json['payment_address'] as String,
  txnId: json['txn_id'] as String,
  txnRef: json['txn_ref'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$PaymentDataToJson(PaymentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_amount': instance.paymentAmount,
      'payment_source': instance.paymentSource,
      'payment_address': instance.paymentAddress,
      'txn_id': instance.txnId,
      'txn_ref': instance.txnRef,
      'created_at': instance.createdAt,
    };

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
  url: json['url'] as String?,
  label: json['label'] as String,
  active: json['active'] as bool,
);

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
  'url': instance.url,
  'label': instance.label,
  'active': instance.active,
};

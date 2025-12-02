import 'package:json_annotation/json_annotation.dart';

part 'chama_reg_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChamaRegistrationResponse {
  final ChamaRegistrationData data;
  final List<dynamic> errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  ChamaRegistrationResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ChamaRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$ChamaRegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaRegistrationResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChamaRegistrationData {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'middle_name')
  final String middleName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String dob;
  final int gender;
  @JsonKey(name: 'id_number')
  final String idNumber;
  @JsonKey(name: 'agent_id')
  final dynamic agentId;
  @JsonKey(name: 'txn_ref')
  final String txnRef;
  final String uuid;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final int id;
  final ChamaUser user;

  ChamaRegistrationData({
    required this.idNumber,
    required this.phoneNumber,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.gender,
    this.agentId,
    required this.txnRef,
    required this.uuid,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.user,
  });

  factory ChamaRegistrationData.fromJson(Map<String, dynamic> json) =>
      _$ChamaRegistrationDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaRegistrationDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChamaUser {
  final int id;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'auth_pin')
  final String authPin;
  @JsonKey(name: 'account_status')
  final String accountStatus;
  final String? email;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @JsonKey(name: 'mywagepay_id')
  final dynamic mywagepayId;
  final List<dynamic> account;
  final ChamaMembership membership;

  ChamaUser({
    required this.id,
    required this.userName,
    required this.authPin,
    required this.accountStatus,
    this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.mywagepayId,
    required this.account,
    required this.membership,
  });

  factory ChamaUser.fromJson(Map<String, dynamic> json) =>
      _$ChamaUserFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaUserToJson(this);
}

@JsonSerializable()
class ChamaMembership {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String source;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'middle_name')
  final String middleName;
  final String dob;
  @JsonKey(name: 'id_number')
  final String idNumber;
  @JsonKey(name: 'id_type')
  final String idType;
  @JsonKey(name: 'tax_id')
  final String? taxId;
  @JsonKey(name: 'approval_status')
  final String? approvalStatus;
  @JsonKey(name: 'txn_ref')
  final String txnRef;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final String uuid;
  final int gender;
  @JsonKey(name: 'agent_id')
  final dynamic agentId;

  ChamaMembership({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.source,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.dob,
    required this.idNumber,
    required this.idType,
    this.taxId,
    this.approvalStatus,
    required this.txnRef,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.uuid,
    required this.gender,
    this.agentId,
  });

  factory ChamaMembership.fromJson(Map<String, dynamic> json) =>
      _$ChamaMembershipFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaMembershipToJson(this);
}
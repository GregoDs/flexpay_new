// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chama_reg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChamaRegistrationResponse _$ChamaRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => ChamaRegistrationResponse(
  data: ChamaRegistrationData.fromJson(json['data'] as Map<String, dynamic>),
  errors: json['errors'] as List<dynamic>,
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$ChamaRegistrationResponseToJson(
  ChamaRegistrationResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

ChamaRegistrationData _$ChamaRegistrationDataFromJson(
  Map<String, dynamic> json,
) => ChamaRegistrationData(
  idNumber: json['id_number'] as String,
  phoneNumber: json['phone_number'] as String,
  firstName: json['first_name'] as String,
  middleName: json['middle_name'] as String,
  lastName: json['last_name'] as String,
  dob: json['dob'] as String,
  gender: (json['gender'] as num).toInt(),
  agentId: json['agent_id'],
  txnRef: json['txn_ref'] as String,
  uuid: json['uuid'] as String,
  userId: (json['user_id'] as num).toInt(),
  updatedAt: json['updated_at'] as String,
  createdAt: json['created_at'] as String,
  id: (json['id'] as num).toInt(),
  user: ChamaUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChamaRegistrationDataToJson(
  ChamaRegistrationData instance,
) => <String, dynamic>{
  'phone_number': instance.phoneNumber,
  'first_name': instance.firstName,
  'middle_name': instance.middleName,
  'last_name': instance.lastName,
  'dob': instance.dob,
  'gender': instance.gender,
  'id_number': instance.idNumber,
  'agent_id': instance.agentId,
  'txn_ref': instance.txnRef,
  'uuid': instance.uuid,
  'user_id': instance.userId,
  'updated_at': instance.updatedAt,
  'created_at': instance.createdAt,
  'id': instance.id,
  'user': instance.user.toJson(),
};

ChamaUser _$ChamaUserFromJson(Map<String, dynamic> json) => ChamaUser(
  id: (json['id'] as num).toInt(),
  userName: json['user_name'] as String,
  authPin: json['auth_pin'] as String,
  accountStatus: json['account_status'] as String,
  email: json['email'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
  mywagepayId: json['mywagepay_id'],
  account: json['account'] as List<dynamic>,
  membership: ChamaMembership.fromJson(
    json['membership'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ChamaUserToJson(ChamaUser instance) => <String, dynamic>{
  'id': instance.id,
  'user_name': instance.userName,
  'auth_pin': instance.authPin,
  'account_status': instance.accountStatus,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
  'mywagepay_id': instance.mywagepayId,
  'account': instance.account,
  'membership': instance.membership.toJson(),
};

ChamaMembership _$ChamaMembershipFromJson(Map<String, dynamic> json) =>
    ChamaMembership(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      phoneNumber: json['phone_number'] as String,
      source: json['source'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      middleName: json['middle_name'] as String,
      dob: json['dob'] as String,
      idNumber: json['id_number'] as String,
      idType: json['id_type'] as String,
      taxId: json['tax_id'] as String?,
      approvalStatus: json['approval_status'] as String?,
      txnRef: json['txn_ref'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      uuid: json['uuid'] as String,
      gender: (json['gender'] as num).toInt(),
      agentId: json['agent_id'],
    );

Map<String, dynamic> _$ChamaMembershipToJson(ChamaMembership instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'phone_number': instance.phoneNumber,
      'source': instance.source,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'middle_name': instance.middleName,
      'dob': instance.dob,
      'id_number': instance.idNumber,
      'id_type': instance.idType,
      'tax_id': instance.taxId,
      'approval_status': instance.approvalStatus,
      'txn_ref': instance.txnRef,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'uuid': instance.uuid,
      'gender': instance.gender,
      'agent_id': instance.agentId,
    };

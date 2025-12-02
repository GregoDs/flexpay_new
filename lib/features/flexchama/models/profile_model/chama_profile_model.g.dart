// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chama_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChamaProfileResponse _$ChamaProfileResponseFromJson(
  Map<String, dynamic> json,
) => ChamaProfileResponse(
  data: json['data'],
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChamaProfileResponseToJson(
  ChamaProfileResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

ChamaProfile _$ChamaProfileFromJson(Map<String, dynamic> json) => ChamaProfile(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  phoneNumber: json['phone_number'] as String?,
  source: json['source'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  middleName: json['middle_name'] as String?,
  dob: json['dob'] as String?,
  idNumber: json['id_number'] as String?,
  idType: json['id_type'] as String?,
  taxId: json['tax_id'] as String?,
  approvalStatus: json['approval_status'] as String?,
  txnRef: json['txn_ref'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
  uuid: json['uuid'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  agentId: (json['agent_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChamaProfileToJson(ChamaProfile instance) =>
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

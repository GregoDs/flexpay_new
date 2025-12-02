import 'package:json_annotation/json_annotation.dart';

part 'chama_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChamaProfileResponse {
  /// `data` can be a Map (profile), a List (e.g. `[{}]`), or null.
  final dynamic data;

  /// Backend returns list of error messages (strings).
  final List<String>? errors;
  final bool? success;

  @JsonKey(name: 'status_code')
  final int? statusCode;

  ChamaProfileResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory ChamaProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ChamaProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaProfileResponseToJson(this);

  /// If `data` is a Map -> parse it to ChamaProfile.
  /// If `data` is a List and the first item is a non-empty Map -> parse that.
  ChamaProfile? get profile {
    try {
      if (data is Map) {
        return ChamaProfile.fromJson(Map<String, dynamic>.from(data as Map));
      }
      if (data is List) {
        final list = data as List;
        if (list.isNotEmpty && list.first is Map) {
          final first = Map<String, dynamic>.from(list.first as Map);
          if (first.isNotEmpty) {
            return ChamaProfile.fromJson(first);
          }
        }
      }
    } catch (_) {
      // parsing failed -> return null
    }
    return null;
  }

  bool get hasProfile => profile != null;
  bool get dataIsNull => data == null;

  /// Returns true for the exact case your backend gives when not found:
  /// { "data": [ {} ], "errors": [...], ... }
  bool get dataIsEmptyListObject {
    if (data is List) {
      final list = data as List;
      return list.isNotEmpty &&
          list.first is Map &&
          (Map.from(list.first as Map)).isEmpty;
    }
    return false;
  }

  String? get firstError => (errors != null && errors!.isNotEmpty) ? errors!.first : null;
}

@JsonSerializable()
class ChamaProfile {
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  final String? source;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'middle_name')
  final String? middleName;

  final String? dob;

  @JsonKey(name: 'id_number')
  final String? idNumber;

  @JsonKey(name: 'id_type')
  final String? idType;

  @JsonKey(name: 'tax_id')
  final String? taxId;

  @JsonKey(name: 'approval_status')
  final String? approvalStatus;

  @JsonKey(name: 'txn_ref')
  final String? txnRef;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  final String? uuid;
  final int? gender;

  @JsonKey(name: 'agent_id')
  final int? agentId;

  ChamaProfile({
    this.id,
    this.userId,
    this.phoneNumber,
    this.source,
    this.firstName,
    this.lastName,
    this.middleName,
    this.dob,
    this.idNumber,
    this.idType,
    this.taxId,
    this.approvalStatus,
    this.txnRef,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.uuid,
    this.gender,
    this.agentId,
  });

  factory ChamaProfile.fromJson(Map<String, dynamic> json) => _$ChamaProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaProfileToJson(this);
}
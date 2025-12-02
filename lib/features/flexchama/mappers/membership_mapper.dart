import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/flexchama/models/profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/registration_model/chama_reg_model.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';

extension MembershipMapper on ChamaMembership {
  ChamaProfile toChamaProfile() {
    return ChamaProfile(
      id: id,
      userId: userId,
      phoneNumber: phoneNumber,
      source: source,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      dob: dob,
      idNumber: idNumber,
      idType: idType,
      taxId: taxId,
      approvalStatus: approvalStatus,
      txnRef: txnRef,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      uuid: uuid,
      gender: gender,
      agentId: agentId is int ? agentId : null, // safe cast
    );
  }
}



extension ChamaProfileMapper on ChamaProfile {
  UserModel toUserModel({String token = ''}) {
    return UserModel(
      token: token, // FlexChama API might not return a token, so default empty
      user: User(
        id: userId ?? 0,
        email: '', // FlexChama profile doesn’t have email → keep empty
        userType: 0, // unknown from FlexChama
        isVerified: approvalStatus == 'approved' ? 1 : 0,
        rememberToken: null,
        profilePicture: null,
        apiToken: null,
        idNumber: idNumber,
        dob: dob,
        phoneNumber: phoneNumber ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        username: [
          firstName ?? '',
          middleName ?? '',
          lastName ?? '',
        ].where((s) => s.isNotEmpty).join(' ').trim(),
      ),
    );
  }
}

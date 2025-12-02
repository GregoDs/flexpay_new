import 'package:equatable/equatable.dart';
import 'package:flexpay/features/flexchama/models/loan_request_model/loan_request_model.dart';
import 'package:flexpay/features/flexchama/models/pay_loan_model/pay_loan_model.dart';
import 'package:flexpay/features/flexchama/models/products_model/chama_products_model.dart';
import 'package:flexpay/features/flexchama/models/profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/registration_model/chama_reg_model.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';
import 'package:flexpay/features/flexchama/models/subscribe_chama_model/subscribe_chama_model.dart';
import 'package:flexpay/features/flexchama/models/withdraw_chama_savings/withdraw_savings_model.dart';
import 'package:flexpay/features/home/models/referral_model/referral_model.dart';

abstract class ChamaState extends Equatable {
  const ChamaState();

  @override
  List<Object?> get props => [];
}

/// ---------------- Profile States ----------------
class ChamaInitial extends ChamaState {}

class ChamaProfileLoading extends ChamaState {}



/// ---------------- Savings States ----------------

class ChamaSavingsLoading extends ChamaState {
  final ChamaProfile? previousProfile;
  final ChamaSavingsResponse? previousSavings; // ✅ Add this

  const ChamaSavingsLoading({
    this.previousProfile,
    this.previousSavings, 
  });

  @override
  List<Object?> get props => [previousProfile, previousSavings];
}


class ChamaProfileFetched extends ChamaState {
  final ChamaProfile profile;

  const ChamaProfileFetched(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ChamaNotMember extends ChamaState {
  final String? message;

  const ChamaNotMember({this.message});

  @override
  List<Object?> get props => [message];
}

class ChamaSavingsFetched extends ChamaState {
  final ChamaSavingsResponse savingsResponse;

  const ChamaSavingsFetched(this.savingsResponse);

  @override
  List<Object?> get props => [savingsResponse];

}

/// ---------------- Registration States ----------------
class ChamaRegistrationInitial extends ChamaState {}

class ChamaRegistrationLoading extends ChamaState {}

class ChamaRegistrationProfile extends ChamaState {
  final ChamaProfile profile;
  final ChamaUser user;

  const ChamaRegistrationProfile({
    required this.profile,
    required this.user,
  });

  @override
  List<Object?> get props => [profile, user];
}

class ChamaRegistrationSuccess extends ChamaState {
  final ChamaRegistrationResponse response;

  const ChamaRegistrationSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ChamaRegistrationFailure extends ChamaState {
  final String message;

  const ChamaRegistrationFailure(this.message);

  @override
  List<Object?> get props => [message];
}




/// ---------------- Get All Chama Products States ----------------

class ChamaAllProductsInitial extends ChamaState {}

class ChamaAllProductsLoading extends ChamaState {}

class ChamaAllProductsFetched extends ChamaState {
  final ChamaProductsResponse productsResponse;

  const ChamaAllProductsFetched(this.productsResponse);

  @override
  List<Object?> get props => [productsResponse];
}

class ChamaAllProductsFailure extends ChamaState {
  final String message;

  const ChamaAllProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}




/// ---------------- Get Users Chamas States ----------------

class UserChamasInitial extends ChamaState {}

class UserChamasLoading extends ChamaState {}

class UserChamasFetched extends ChamaState {
  final UserChamasResponse productsResponse;

  const UserChamasFetched(this.productsResponse);

  @override
  List<Object?> get props => [productsResponse];
}

class UserChamasFailure extends ChamaState {
  final String message;

  const UserChamasFailure(this.message);

  @override
  List<Object?> get props => [message];
}



/// ---------------- Error States ----------------
class ChamaError extends ChamaState {
  final String message;

  const ChamaError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- View Chama sub class ----------------

class ChamaViewState extends ChamaState {
  final bool isLoading;
  final bool isWalletLoading;
  final bool isListLoading;
  final ChamaSavingsResponse? savings;
  final UserChamasResponse? userChamas;
  final ChamaProductsResponse? allProducts;

  const ChamaViewState({
    this.isLoading = false,
    this.isListLoading =false,
    this.isWalletLoading = false,
    this.savings,
    this.userChamas,
    this.allProducts,
  });

  ChamaViewState copyWith({
    bool? isLoading,
    ChamaSavingsResponse? savings,
    UserChamasResponse? userChamas,
    ChamaProductsResponse? allProducts,
  }) {
    return ChamaViewState(
      isLoading: isLoading ?? this.isLoading,
      savings: savings ?? this.savings,
      userChamas: userChamas ?? this.userChamas,
      allProducts: allProducts ?? this.allProducts,
    );
  }

  @override
  List<Object?> get props => [isLoading, savings, userChamas, allProducts];

}

  /// ---------------- Subscribe to chama states  ----------------
class SubscribeChamaLoading extends ChamaState {}

class SubscribeChamaSuccess extends ChamaState {
  final SubscribeChamaResponse response;

  const SubscribeChamaSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class SubscribeChamaFailure extends ChamaState {
  final String message;

  const SubscribeChamaFailure(this.message);

  @override
  List<Object?> get props => [message];
}


/// ---------------- Save to Chama states ----------------
class SaveToChamaLoading extends ChamaState {}

class SaveToChamaSuccess extends ChamaState {
  final SubscribeChamaResponse response; 

  const SaveToChamaSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class SaveToChamaFailure extends ChamaState {
  final String message;

  const SaveToChamaFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Save to Chama (Wallet) states ----------------
class PayChamaWalletLoading extends ChamaState {}

class PayChamaWalletSuccess extends ChamaState {
  final SaveChamaWalletResponse response;

  const PayChamaWalletSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PayChamaWalletFailure extends ChamaState {
  final String message;

  const PayChamaWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Referral States ----------------
class ChamaReferralInitial extends ChamaState {}

class ChamaReferralLoading extends ChamaState {}

class ChamaReferralSuccess extends ChamaState {
  final ReferralResponse referralResponse;

  const ChamaReferralSuccess(this.referralResponse);

  @override
  List<Object?> get props => [referralResponse];
}

class ChamaReferralFailure extends ChamaState {
  final String message;

  const ChamaReferralFailure(this.message);

  @override
  List<Object?> get props => [message];
}


/// ---------------- Withdraw Chama Savings States ----------------
class WithdrawChamaSavingsLoading extends ChamaState {}

class WithdrawChamaSavingsSuccess extends ChamaState {
  final WithdrawChamaSavingsResponse response;

  const WithdrawChamaSavingsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class WithdrawChamaSavingsFailure extends ChamaState {
  final String message;

  const WithdrawChamaSavingsFailure(this.message);

  @override
  List<Object?> get props => [message];
}




/// ---------------- Request Chama Loan States ----------------
class RequestChamaLoanLoading extends ChamaState {}

class RequestChamaLoanSuccess extends ChamaState {
  final ChamaLoanRequestResponse response;

  const RequestChamaLoanSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RequestChamaLoanFailure extends ChamaState {
  final String message;

  const RequestChamaLoanFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Repay Chama Loan States ----------------
class RepayChamaLoanLoading extends ChamaState {}

class RepayChamaLoanSuccess extends ChamaState {
  final PayLoanResponse response;

  const RepayChamaLoanSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RepayChamaLoanFailure extends ChamaState {
  final String message;

  const RepayChamaLoanFailure(this.message);

  @override
  List<Object?> get props => [message];
}
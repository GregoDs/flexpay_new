import 'package:equatable/equatable.dart';
import 'package:flexpay/features/home/models/home_wallet_model/wallet_model.dart';
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:flexpay/features/home/models/referral_model/referral_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// ---------------- Wallet States ----------------
class HomeWalletInitial extends HomeState {}

class HomeWalletLoading extends HomeState {}

class HomeWalletFetched extends HomeState {
  final WalletResponse walletResponse;

  const HomeWalletFetched(this.walletResponse);

  @override
  List<Object?> get props => [walletResponse];
}

class HomeWalletFailure extends HomeState {
  final String message;

  const HomeWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Transactions States ----------------
class HomeTransactionsInitial extends HomeState {}

class HomeTransactionsLoading extends HomeState {}

class HomeTransactionsFetched extends HomeState {
  final LatestTransactionsResponse transactionsResponse;

  const HomeTransactionsFetched(this.transactionsResponse);

  @override
  List<Object?> get props => [transactionsResponse];
}

class HomeTransactionsFailure extends HomeState {
  final String message;

  const HomeTransactionsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Referral States ----------------
class HomeReferralInitial extends HomeState {}

class HomeReferralLoading extends HomeState {}

class HomeReferralSuccess extends HomeState {
  final ReferralResponse referralResponse;

  const HomeReferralSuccess(this.referralResponse);

  @override
  List<Object?> get props => [referralResponse];
}

class HomeReferralFailure extends HomeState {
  final String message;

  const HomeReferralFailure(this.message);

  @override
  List<Object?> get props => [message];
}

///Unified state
class HomeCombinedState extends HomeState {
  final bool isWalletLoading;
  final bool isTransactionsLoading;
  final WalletResponse? walletResponse;
  final LatestTransactionsResponse? transactionsResponse;
  final String? errorMessage;

  const HomeCombinedState({
    this.isWalletLoading = false,
    this.isTransactionsLoading = false,
    this.walletResponse,
    this.transactionsResponse,
    this.errorMessage,
  });

  HomeCombinedState copyWith({
    bool? isWalletLoading,
    bool? isTransactionsLoading,
    WalletResponse? walletResponse,
    LatestTransactionsResponse? transactionsResponse,
    String? errorMessage,
  }) {
    return HomeCombinedState(
      isWalletLoading: isWalletLoading ?? this.isWalletLoading,
      isTransactionsLoading:
          isTransactionsLoading ?? this.isTransactionsLoading,
      walletResponse: walletResponse ?? this.walletResponse,
      transactionsResponse: transactionsResponse ?? this.transactionsResponse,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isWalletLoading,
    isTransactionsLoading,
    walletResponse,
    transactionsResponse,
    errorMessage,
  ];
}

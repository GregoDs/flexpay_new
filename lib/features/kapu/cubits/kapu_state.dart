import 'package:equatable/equatable.dart';
import 'package:flexpay/features/kapu/models/kapu_balance_model/all_wallets_model.dart';
import 'package:flexpay/features/kapu/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/kapu/models/kapu_shops/kapu_shops_model.dart';
import 'package:flexpay/features/kapu/models/kapu_topup_model/kapu_topup_model.dart';
import 'package:flexpay/features/kapu/models/kapu_transfer_model/kapu_transfer_model.dart';
import 'package:flexpay/features/kapu/models/kapu_debit_model/kapu_debit_model.dart';
import 'package:flexpay/features/kapu/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/features/kapu/models/kapu_voucher_model/kapu_voucher_model.dart'; // ✅ added
import 'package:flexpay/features/kapu/models/kapu_topup_model/kapu_wallet_topup_model.dart';

abstract class KapuState extends Equatable {
  const KapuState();

  @override
  List<Object?> get props => [];
}

/// ---------------- WALLET STATES ---------------- ///
class KapuStateInitial extends KapuState {}

class KapuWalletInitial extends KapuState {}

class KapuWalletLoading extends KapuState {}

class KapuWalletFetched extends KapuState {
  final KapuWalletBalances kapuWalletResponse;
  final String merchantId;

  const KapuWalletFetched(this.kapuWalletResponse, this.merchantId);

  @override
  List<Object?> get props => [kapuWalletResponse, merchantId];
}

class KapuWalletListFetched extends KapuState {
  final List<KapuWalletBalances> wallets;

  const KapuWalletListFetched(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

class KapuWalletFailure extends KapuState {
  final String message;

  const KapuWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- TRANSFER STATES ---------------- ///
class KapuTransferLoading extends KapuState {}

class KapuTransferSuccess extends KapuState {
  final KapuTransferModel response;

  const KapuTransferSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuTransferFailure extends KapuState {
  final String message;

  const KapuTransferFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- DEBIT STATES ---------------- ///
class KapuDebitLoading extends KapuState {}

class KapuDebitSuccess extends KapuState {
  final DebitResponseModel response;

  const KapuDebitSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuDebitFailure extends KapuState {
  final String message;

  const KapuDebitFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- BOOKING STATES ---------------- ///
class KapuBookingLoading extends KapuState {}

class KapuBookingSuccess extends KapuState {
  final KapuBookingResponse response;

  const KapuBookingSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuBookingFailure extends KapuState {
  final String message;

  const KapuBookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- VOUCHER STATES ---------------- /// ✅ UPDATED
class KapuVoucherLoading extends KapuState {}

class KapuVoucherSuccess extends KapuState {
  final CreateVoucherResponse response;

  const KapuVoucherSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuVoucherFailure extends KapuState {
  final String message;

  const KapuVoucherFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- SHOPS FETCH STATES ---------------- ///
class KapuShopsLoading extends KapuState {}

class KapuShopsFetched extends KapuState {
  final OutletResponse response;

  const KapuShopsFetched(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuShopsFailure extends KapuState {
  final String message;

  const KapuShopsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- TOP-UP STATES ---------------- ///
class KapuTopUpLoading extends KapuState {}

class KapuTopUpSuccess extends KapuState {
  final KapuTopUpResponse response;

  const KapuTopUpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuTopUpFailure extends KapuState {
  final String message;

  const KapuTopUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- WALLET TOP-UP FROM WALLET STATES ---------------- ///
class KapuWalletTopUpLoading extends KapuState {}

class KapuWalletTopUpSuccess extends KapuState {
  final KapuWalletTopUpResponse response;
  const KapuWalletTopUpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuWalletTopUpFailure extends KapuState {
  final String message;
  const KapuWalletTopUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- FETCH ALL WALLETS INSTANTLY STATES ---------------- ///
class KapuAllWalletsInstantlyLoading extends KapuState {}

class KapuAllWalletsInstantlyFetched extends KapuState {
  final AllWalletsKapuModel walletsResponse;

  const KapuAllWalletsInstantlyFetched(this.walletsResponse);

  @override
  List<Object?> get props => [walletsResponse];
}

class KapuAllWalletsInstantlyFailure extends KapuState {
  final String message;

  const KapuAllWalletsInstantlyFailure(this.message);

  @override
  List<Object?> get props => [message];
}

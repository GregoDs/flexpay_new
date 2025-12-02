import 'package:equatable/equatable.dart';
import 'package:flexpay/features/payments/models/refunds_model/refunds_model.dart';
import 'package:flexpay/features/payments/models/top_up_wallet_model/topup_wallet_model.dart';
import 'package:flexpay/features/payments/models/voucher_model/voucher_model.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object?> get props => [];
}

class PaymentsInitial extends PaymentsState {}

/// ---------------- Refund from wallet States ----------------
class WalletRefundInitial extends PaymentsState {}

class WalletRefundLoading extends PaymentsState {}

class WalletRefundFetched extends PaymentsState {
  final RefundResponse refundResponse;

  const WalletRefundFetched(this.refundResponse);

  @override
  List<Object?> get props => [refundResponse];
}

class WalletRefundFailure extends PaymentsState {
  final String message;

  const WalletRefundFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Top Up Wallet via M-Pesa States ----------------
class WalletTopUpInitial extends PaymentsState {}

class WalletTopUpLoading extends PaymentsState {}

class WalletTopUpSuccess extends PaymentsState {
  final TopUpWalletHomeResponse response;

  const WalletTopUpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class WalletTopUpFailure extends PaymentsState {
  final String message;

  const WalletTopUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}



/// ---------------- Voucher States ----------------
class VoucherInitial extends PaymentsState {}

class VoucherLoading extends PaymentsState {}

class VoucherSuccess extends PaymentsState {
  final VoucherResponse response;

  const VoucherSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class VoucherFailure extends PaymentsState {
  final String message;

  const VoucherFailure(this.message);

  @override
  List<Object?> get props => [message];
}
import 'package:equatable/equatable.dart';
import 'package:flexpay/features/goals/models/create_goal_response.dart/create_goal_response.dart';
import 'package:flexpay/features/goals/models/goals_model/show_goals_model.dart';
import 'package:flexpay/features/goals/models/goals_payment_model/goals_payment_model.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object?> get props => [];
}

// 🟢 Initial state
class GoalsInitial extends GoalsState {}

// 🟢 Create Goal States
class CreateGoalsLoading extends GoalsState {}

class CreateGoalsSuccess extends GoalsState {
  final CreateGoalResponse response;
  const CreateGoalsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CreateGoalsError extends GoalsState {
  final String message;
  const CreateGoalsError(this.message);

  @override
  List<Object?> get props => [message];
}



// 🟢 Fetch Goals States
class FetchGoalsLoading extends GoalsState {}

class FetchGoalsSuccess extends GoalsState {
  final List<GoalData> goals; // list of fetched goals
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  const FetchGoalsSuccess({
    required this.goals,
    required this.currentPage,
    required this.lastPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [goals, currentPage, lastPage, hasMore];
}

class FetchGoalsError extends GoalsState {
  final String message;
  const FetchGoalsError(this.message);

  @override
  List<Object?> get props => [message];
}




// Wallet Payment states //
class GoalWalletPaymentLoading extends GoalsState {}

class GoalWalletPaymentSuccess extends GoalsState {
  final GoalWalletPaymentResponse response;

  const GoalWalletPaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class GoalWalletPaymentError extends GoalsState {
  final String message;

  const GoalWalletPaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Mpesa Payment states //
class GoalMpesaPaymentLoading extends GoalsState {}

class GoalMpesaPaymentSuccess extends GoalsState {
  final GoalMpesaPaymentResponse response;

  const GoalMpesaPaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class GoalMpesaPaymentError extends GoalsState {
  final String message;

  const GoalMpesaPaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
import 'package:bloc/bloc.dart';
import 'package:flexpay/features/goals/cubits/goals_state.dart';
import 'package:flexpay/features/goals/models/create_goal_response.dart/create_goal_response.dart';
import 'package:flexpay/features/goals/models/goals_model/show_goals_model.dart';
import 'package:flexpay/features/goals/repo/goals_repo.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class GoalsCubit extends Cubit<GoalsState> {
  final GoalsRepo _repo;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetching = false;
  final List<GoalData> _allGoals = [];

  GoalsCubit(this._repo) : super(GoalsInitial());

  // -------------------------------------------------------------------------
  // 🟢 CREATE A NEW GOAL
  // -------------------------------------------------------------------------
  Future<void> createGoal({
    required String productName,
    required String targetAmount,
    required String startDate,
    required String endDate,
    required String frequency,
    required String frequencyContribution,
    required String deposit,
  }) async {
    emit(CreateGoalsLoading());
    try {
      final CreateGoalResponse response = await _repo.createGoal(
        productName: productName,
        targetAmount: targetAmount,
        startDate: startDate,
        endDate: endDate,
        frequency: frequency,
        frequencyContribution: frequencyContribution,
        deposit: deposit,
      );

      if (response.success == true) {
        emit(CreateGoalsSuccess(response));
      } else {
        emit(const CreateGoalsError("Goal creation failed. Please try again."));
      }
    } catch (e) {
      emit(CreateGoalsError(ErrorHandler.handleGenericError(e)));
    }
  }

  // -------------------------------------------------------------------------
  // 🟢 FETCH GOALS (Paginated)
  // -------------------------------------------------------------------------
  Future<void> fetchGoals({bool loadMore = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (!loadMore) {
        emit(FetchGoalsLoading());
        _currentPage = 1;
        _allGoals.clear();
      }

      final response = await _repo.fetchGoals(page: _currentPage);

      if (response.success == true) {
        final pageData = response.data?.goals;
        final List<GoalData> newGoals = pageData?.data ?? [];

        _currentPage = pageData?.currentPage ?? 1;
        _lastPage = pageData?.lastPage ?? 1;

        _allGoals.addAll(newGoals);

        emit(FetchGoalsSuccess(
          goals: List.from(_allGoals),
          currentPage: _currentPage,
          lastPage: _lastPage,
          hasMore: _currentPage < _lastPage,
        ));

        // Increment for next loadMore call
        _currentPage++;
      } else {
        emit(const FetchGoalsError("Failed to fetch goals. Please try again."));
      }
    } catch (e) {
      emit(FetchGoalsError(ErrorHandler.handleGenericError(e)));
    } finally {
      _isFetching = false;
    }
  }



  /// Wallet payment flow
  Future<void> payGoalFromWallet(
    String bookingReference,
    double debitAmount,
  ) async {
    emit(GoalWalletPaymentLoading());
    try {
      final response = await _repo.payGoalFromWallet(
        bookingReference,
        debitAmount,
      );
      emit(GoalWalletPaymentSuccess(response));
    } catch (e) {
      emit(
        GoalWalletPaymentError(
          'Failed to pay for Goal from wallet. ${e.toString()}',
        ),
      );
    }
  }

  /// Mpesa payment flow
Future<void> payGoalViaMpesa(
  String bookingReference,
  double amount,
  String phoneNumber,
) async {
  emit(GoalMpesaPaymentLoading());
  try {
    final response = await _repo.payGoalViaMpesa(
      bookingReference,
      amount,
      phoneNumber,
    );
    emit(GoalMpesaPaymentSuccess(response));
  } catch (e) {
    emit(
      GoalMpesaPaymentError(
        'Failed to pay goal via Mpesa. ${e.toString()}',
      ),
    );
  }
}

}
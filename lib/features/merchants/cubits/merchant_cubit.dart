import 'package:flexpay/features/merchants/cubits/merchant_state.dart';
import 'package:flexpay/features/merchants/repo/merchants_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MerchantsCubit extends Cubit<MerchantsState> {
  final MerchantsRepository _repository;

  MerchantsCubit(this._repository) : super(MerchantsInitial());

  Future<void> fetchMerchants(String type) async {
    emit(MerchantsLoading());

    try {
      final merchants = await _repository.fetchMerchants();

      if (merchants.isEmpty) {
        emit(MerchantsError("No $type merchants found."));
      } else {
        emit(MerchantsFetched(merchants: merchants));
      }
    } catch (e) {
      emit(MerchantsError("Failed to load $type merchants. ${e.toString()}"));
    }
  }
}
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'connectivity_service.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final ConnectivityService _service;
  StreamSubscription<bool>? _sub;

  InternetCubit(this._service) : super(InternetInitial()) {
    // start service and subscribe
    _service.start();
    _sub = _service.onStatusChange.listen((connected) {
      if (connected) {
        emit(InternetConnected());
      } else {
        emit(InternetDisconnected());
      }
    });
    // reflect current known state
    if (_service.lastStatus) {
      emit(InternetConnected());
    } else {
      emit(InternetDisconnected());
    }
  }

  bool get isConnected => state is InternetConnected;

  @override
  Future<void> close() {
    _sub?.cancel();
    _service.dispose();
    return super.close();
  }
}
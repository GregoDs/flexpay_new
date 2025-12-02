import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Emits true when real internet is available, false otherwise.
/// Debounces small rapid changes.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final InternetConnection _internetChecker = InternetConnection();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  Stream<bool> get onStatusChange => _controller.stream;

  // keep last known state
  bool _hasInternet = true;
  bool get lastStatus => _hasInternet;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  StreamSubscription<InternetStatus>? _internetSub;

  void start() {
    // Listen to connectivity changes (wifi/mobile/none)
    _connectivitySub = _connectivity.onConnectivityChanged.listen((_) {
      _checkInternet();
    });

    // Also listen to internet checker status (ping)
    _internetSub = _internetChecker.onStatusChange.listen((status) {
      final connected = status == InternetStatus.connected;
      _emitIfChanged(connected);
    });

    // initial check
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    try {
      final hasConnection = await _internetChecker.hasInternetAccess;
      _emitIfChanged(hasConnection);
    } catch (_) {
      _emitIfChanged(false);
    }
  }

  void _emitIfChanged(bool connected) {
    if (_hasInternet != connected) {
      _hasInternet = connected;
      _controller.add(_hasInternet);
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
    _internetSub?.cancel();
    _controller.close();
  }
}

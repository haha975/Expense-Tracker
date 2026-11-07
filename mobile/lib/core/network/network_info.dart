import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity is a hint, not proof that the API is reachable.
abstract class NetworkInfo {
  Future<bool> get hasConnectionHint;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get hasConnectionHint async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}

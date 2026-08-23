import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'app_link_url.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImp implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImp({required this.internetConnectionChecker});

  @override
  Future<bool> get isConnected {
    final apiUri = Uri.tryParse(AppLinkUrl.baseUrl);

    // Local API addresses can be reached through `adb reverse` even when the
    // device cannot reach the public hosts used by InternetConnectionChecker.
    if (apiUri != null && _isLocalhost(apiUri.host)) {
      return Future.value(true);
    }

    return internetConnectionChecker.hasConnection;
  }

  bool _isLocalhost(String host) {
    final normalizedHost = host.toLowerCase();
    return normalizedHost == 'localhost' ||
        normalizedHost.endsWith('.localhost') ||
        normalizedHost == '127.0.0.1' ||
        normalizedHost == '::1';
  }
}

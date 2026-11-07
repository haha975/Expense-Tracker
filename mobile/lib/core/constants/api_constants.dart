/// HTTP API configuration.
///
/// Override the local default at build/run time:
///
/// ```sh
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
/// ```
///
/// Or load from a file:
///
/// ```sh
/// flutter run --dart-define-from-file=env.json
/// ```
///
/// See `env.example.json` in the mobile project root.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const String healthPath = '/health';
}

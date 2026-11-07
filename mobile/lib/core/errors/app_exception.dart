class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No network connection is available.',
  ]);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'The server could not complete the request.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class CacheException extends AppException {
  const CacheException([
    super.message = 'Local data could not be read or saved.',
  ]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Authentication is required.',
    int? statusCode = 401,
  ]) : super(statusCode: statusCode);
}

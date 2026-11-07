import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/constants/storage_keys.dart';
import 'package:mobile/core/errors/app_exception.dart';

class DioClient {
  DioClient({
    required this._secureStorage,
    String? baseUrl,
    Dio? dio,
  }) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: StorageKeys.accessToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(_mapDioError(error));
        },
      ),
    );
  }

  final FlutterSecureStorage _secureStorage;
  late final Dio _dio;

  Dio get dio => _dio;

  DioException _mapDioError(DioException error) {
    final mapped = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => const NetworkException(),
      DioExceptionType.badResponse => _mapStatusCode(
        error.response?.statusCode,
      ),
      _ => const ServerException(),
    };

    return error.copyWith(error: mapped);
  }

  AppException _mapStatusCode(int? statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedException('Authentication is required.', statusCode);
    }
    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        'The server could not complete the request.',
        statusCode,
      );
    }
    if (statusCode != null && statusCode >= 400) {
      return ServerException(
        'The request was rejected by the server.',
        statusCode,
      );
    }
    return const ServerException();
  }
}

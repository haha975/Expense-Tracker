import 'package:dio/dio.dart';
import 'package:mobile/core/errors/app_exception.dart';
import 'package:mobile/core/errors/failure.dart';

Failure mapToFailure(Object error) {
  if (error is Failure) {
    return error;
  }

  if (error is DioException && error.error != null) {
    return mapToFailure(error.error!);
  }

  if (error is AppException) {
    return switch (error) {
      NetworkException() => NetworkFailure(error.message),
      UnauthorizedException() => UnauthorizedFailure(error.message),
      CacheException() => CacheFailure(error.message),
      ServerException() => ServerFailure(error.message),
      AppException() => UnexpectedFailure(error.message),
    };
  }

  return const UnexpectedFailure();
}

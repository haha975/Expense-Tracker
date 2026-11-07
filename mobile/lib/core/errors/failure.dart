import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No network connection is available.']);
}

final class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'The server could not complete the request.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Local data could not be read or saved.',
  ]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'The submitted data is invalid.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Authentication is required.']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}


import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    return const FailureResult<void>(
      UnexpectedFailure(
        'Authentication is not connected to a backend yet.',
      ),
    );
  }
}

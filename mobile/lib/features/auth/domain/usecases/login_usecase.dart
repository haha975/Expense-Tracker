
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(
      email: email.trim(),
      password: password,
    );
  }
}

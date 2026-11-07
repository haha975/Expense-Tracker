
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this._loginUseCase})
    : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final result = await _loginUseCase(
        email: event.email,
        password: event.password,
      );

      result.when(
        success: (_) => emit(const Authenticated()),
        failure: (failure) => emit(AuthFailure(failure.message)),
      );
    } catch (_) {
      emit(
        const AuthFailure(
          'Something went wrong. Please try again.',
        ),
      );
    }
  }
}

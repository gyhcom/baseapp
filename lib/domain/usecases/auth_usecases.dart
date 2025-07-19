import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Login use case
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({required String email, required String password}) async {
    return await _repository.login(email: email, password: password);
  }
}

/// Register use case
class RegisterUseCase {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}

/// Logout use case
class LogoutUseCase {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() async {
    await _repository.logout();
  }
}

/// Get current user use case
class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call() async {
    return await _repository.getCurrentUser();
  }
}

import '../entities/user_auth.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<UserAuth?> signInWithGoogle() async {
    try {
      final userAuth = await _authRepository.signInWithGoogle();
      return userAuth;
    } catch (e) {
      throw Exception('Google 로그인 실패: $e');
    }
  }

  Future<UserAuth?> signInWithApple() async {
    try {
      final userAuth = await _authRepository.signInWithApple();
      return userAuth;
    } catch (e) {
      throw Exception('Apple 로그인 실패: $e');
    }
  }

  Future<UserAuth?> signInAnonymously() async {
    try {
      final userAuth = await _authRepository.signInAnonymously();
      return userAuth;
    } catch (e) {
      throw Exception('익명 로그인 실패: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      throw Exception('로그아웃 실패: $e');
    }
  }

  Future<UserAuth?> getCurrentUser() async {
    try {
      return await _authRepository.getCurrentUserAuth();
    } catch (e) {
      throw Exception('사용자 정보 가져오기 실패: $e');
    }
  }

  Stream<UserAuth?> get authStateChanges => _authRepository.authStateChanges;

  bool get isSignedIn => _authRepository.isSignedIn;
}
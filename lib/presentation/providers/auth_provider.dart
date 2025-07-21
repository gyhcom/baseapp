import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_auth.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../di/service_locator.dart';

// AuthUseCase Provider
final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  return getIt<AuthUseCase>();
});

// Current User Provider
final currentUserProvider = FutureProvider<UserAuth?>((ref) async {
  final authUseCase = ref.read(authUseCaseProvider);
  return await authUseCase.getCurrentUser();
});

// Auth State Provider
final authStateProvider = StreamProvider<bool>((ref) {
  final authUseCase = ref.read(authUseCaseProvider);
  return authUseCase.authStateChanges.map((user) => user != null);
});

// Auth Status Provider (sync)
final isSignedInProvider = Provider<bool>((ref) {
  final authUseCase = ref.read(authUseCaseProvider);
  return authUseCase.isSignedIn;
});

// Auth Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authUseCaseProvider));
});

// Auth Controller
class AuthController extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;

  AuthController(this._authUseCase) : super(const AuthState.initial());

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      final userAuth = await _authUseCase.signInWithGoogle();
      if (userAuth != null) {
        state = AuthState.authenticated(userAuth);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    state = const AuthState.loading();
    try {
      final userAuth = await _authUseCase.signInWithApple();
      if (userAuth != null) {
        state = AuthState.authenticated(userAuth);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signInAnonymously() async {
    state = const AuthState.loading();
    try {
      final userAuth = await _authUseCase.signInAnonymously();
      if (userAuth != null) {
        state = AuthState.authenticated(userAuth);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authUseCase.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final userAuth = await _authUseCase.getCurrentUser();
      if (userAuth != null) {
        state = AuthState.authenticated(userAuth);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

// Auth State
class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserAuth user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final UserAuth user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
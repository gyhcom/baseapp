import '../entities/user_auth.dart';

abstract class AuthService {
  Future<void> initialize();
  
  Future<UserAuth?> signInWithGoogle();
  Future<UserAuth?> signInWithApple();
  Future<UserAuth?> signInAnonymously();
  
  Future<void> signOut();
  
  UserAuth? getCurrentUser();
  Stream<UserAuth?> get authStateChanges;
  
  bool get isSignedIn;
}
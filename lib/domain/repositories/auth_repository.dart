import '../entities/user.dart';
import '../entities/user_auth.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Social login methods
  Future<UserAuth?> signInWithGoogle();
  Future<UserAuth?> signInWithApple();
  Future<UserAuth?> signInAnonymously();
  
  /// Sign out
  Future<void> signOut();
  
  /// Local storage for auth data
  Future<void> saveUserAuth(UserAuth userAuth);
  Future<UserAuth?> getCurrentUserAuth();
  
  /// Auth state stream
  Stream<UserAuth?> get authStateChanges;
  
  /// Auth status check
  bool get isSignedIn;

  /// Legacy email/password authentication
  Future<User> login({required String email, required String password});

  /// Register new user
  Future<User> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Refresh authentication token
  Future<void> refreshToken();

  /// Send forgot password email
  Future<void> forgotPassword({required String email});

  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<void> verifyEmail({required String token});

  /// Update user profile
  Future<User> updateProfile({required Map<String, dynamic> userData});

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account
  Future<void> deleteAccount();
}

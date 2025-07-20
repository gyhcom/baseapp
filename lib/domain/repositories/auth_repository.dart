import '../entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with email and password
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

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_storage.dart';
import '../datasources/remote/api_service.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiService apiService,
    required LocalStorage localStorage,
  }) : _apiService = apiService,
       _localStorage = localStorage;

  final ApiService _apiService;
  final LocalStorage _localStorage;

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _apiService.login(email: email, password: password);

    final data = response.data as Map<String, dynamic>;
    final userData = data['data'] as Map<String, dynamic>;

    // Store tokens
    await _localStorage.setAccessToken(userData['access_token'] as String);
    await _localStorage.setRefreshToken(userData['refresh_token'] as String);

    // Store user data
    final userInfo = userData['user'] as Map<String, dynamic>;
    await _localStorage.setUserData(userInfo);

    return _mapToUser(userInfo);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _apiService.register(
      email: email,
      password: password,
      name: name,
    );

    final data = response.data as Map<String, dynamic>;
    final userData = data['data'] as Map<String, dynamic>;

    // Store tokens
    await _localStorage.setAccessToken(userData['access_token'] as String);
    await _localStorage.setRefreshToken(userData['refresh_token'] as String);

    // Store user data
    final userInfo = userData['user'] as Map<String, dynamic>;
    await _localStorage.setUserData(userInfo);

    return _mapToUser(userInfo);
  }

  @override
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Continue with local logout even if API call fails
    }

    await _localStorage.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = await _localStorage.getUserData();
    if (userData == null) return null;

    return _mapToUser(userData);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localStorage.isLoggedIn;
  }

  @override
  Future<void> refreshToken() async {
    final refreshToken = await _localStorage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');

    final response = await _apiService.refreshToken(refreshToken: refreshToken);

    final data = response.data as Map<String, dynamic>;
    final tokenData = data['data'] as Map<String, dynamic>;

    await _localStorage.setAccessToken(tokenData['access_token'] as String);
    await _localStorage.setRefreshToken(tokenData['refresh_token'] as String);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _apiService.forgotPassword(email: email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _apiService.resetPassword(token: token, newPassword: newPassword);
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    await _apiService.verifyEmail(token: token);
  }

  @override
  Future<User> updateProfile({required Map<String, dynamic> userData}) async {
    final response = await _apiService.updateUserProfile(userData: userData);

    final data = response.data as Map<String, dynamic>;
    final userInfo = data['data'] as Map<String, dynamic>;

    // Update local user data
    await _localStorage.setUserData(userInfo);

    return _mapToUser(userInfo);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _apiService.deleteAccount();
    await _localStorage.logout();
  }

  /// Map API response to User entity
  User _mapToUser(Map<String, dynamic> data) {
    return User(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
      avatar: data['avatar'] as String?,
      isEmailVerified: data['email_verified'] as bool? ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }
}

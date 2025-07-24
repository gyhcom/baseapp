import 'package:hive/hive.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/user_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/auth_service.dart';
import '../datasources/local/local_storage.dart';
import '../datasources/remote/api_service.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiService apiService,
    required LocalStorage localStorage,
    AuthService? authService,
    Box<UserAuth>? userAuthBox,
  }) : _apiService = apiService,
       _localStorage = localStorage,
       _authService = authService,
       _userAuthBox = userAuthBox;

  final ApiService _apiService;
  final LocalStorage _localStorage;
  final AuthService? _authService;
  final Box<UserAuth>? _userAuthBox;

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

  // Social login methods
  @override
  Future<UserAuth?> signInWithGoogle() async {
    if (_authService == null) throw Exception('Auth service not configured');
    final userAuth = await _authService!.signInWithGoogle();
    if (userAuth != null) {
      await saveUserAuth(userAuth);
    }
    return userAuth;
  }

  @override
  Future<UserAuth?> signInWithApple() async {
    if (_authService == null) throw Exception('Auth service not configured');
    final userAuth = await _authService!.signInWithApple();
    if (userAuth != null) {
      await saveUserAuth(userAuth);
    }
    return userAuth;
  }

  @override
  Future<UserAuth?> signInAnonymously() async {
    if (_authService == null) throw Exception('Auth service not configured');
    final userAuth = await _authService!.signInAnonymously();
    if (userAuth != null) {
      await saveUserAuth(userAuth);
    }
    return userAuth;
  }

  @override
  Future<void> signOut() async {
    if (_authService != null) {
      await _authService!.signOut();
    }
    await _userAuthBox?.clear();
  }

  @override
  Future<void> saveUserAuth(UserAuth userAuth) async {
    await _userAuthBox?.put('current_user', userAuth);
  }

  @override
  Future<UserAuth?> getCurrentUserAuth() async {
    // Firebase 실시간 상태를 우선적으로 확인
    if (_authService != null) {
      final firebaseUser = _authService!.getCurrentUser();
      
      if (firebaseUser != null) {
        // Firebase에서 사용자 정보를 가져온 경우, 로컬 저장소 업데이트
        await saveUserAuth(firebaseUser);
        print('🔄 Firebase에서 사용자 정보 동기화: ${firebaseUser.displayName} (${firebaseUser.email})');
        return firebaseUser;
      } else {
        // Firebase에 사용자가 없으면 로컬 저장소도 클리어
        await _userAuthBox?.clear();
        print('🗑️ Firebase 로그아웃 상태로 로컬 데이터 클리어');
        return null;
      }
    }
    
    // AuthService가 없는 경우에만 로컬 저장소에서 가져오기
    final localUser = _userAuthBox?.get('current_user');
    if (localUser != null) {
      print('📦 로컬 저장소에서 사용자 정보 로드: ${localUser.displayName} (${localUser.email})');
    }
    return localUser;
  }

  @override
  Stream<UserAuth?> get authStateChanges {
    if (_authService == null) return Stream.value(null);
    return _authService!.authStateChanges;
  }

  @override
  bool get isSignedIn {
    if (_authService == null) return false;
    return _authService!.isSignedIn;
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

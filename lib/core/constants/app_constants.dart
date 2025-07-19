/// App-wide constants and configuration values
class AppConstants {
  // ========== APP INFO ==========
  static const String appName = 'BaseApp';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // ========== NETWORK ==========
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ========== DATABASE ==========
  static const String hiveBoxName = 'baseapp_box';
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';

  // ========== STORAGE KEYS ==========
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String isFirstLaunchKey = 'is_first_launch';

  // ========== VALIDATION ==========
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 254;

  // ========== PAGINATION ==========
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ========== ANIMATION ==========
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // ========== UI ==========
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 8.0;
  static const double smallBorderRadius = 4.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;

  // ========== FEATURE FLAGS ==========
  /// Enable Firebase Authentication
  /// Set to false to disable Firebase auth and use mock authentication
  static const bool enableFirebaseAuth = true;

  /// Enable push notifications
  /// Set to false to disable push notification functionality
  static const bool enablePushNotifications = true;

  /// Enable analytics
  /// Set to false to disable analytics tracking
  static const bool enableAnalytics = true;

  /// Enable crash reporting
  /// Set to false to disable crash reporting
  static const bool enableCrashReporting = true;

  /// Enable logging in production
  /// Set to false to disable logging in release builds
  static const bool enableProductionLogging = false;

  // ========== ENVIRONMENT SPECIFIC ==========
  static const String _devApiUrl = 'https://dev-api.baseapp.com';
  static const String _stagingApiUrl = 'https://staging-api.baseapp.com';
  static const String _prodApiUrl = 'https://api.baseapp.com';

  /// Get API URL based on build mode
  static String get apiUrl {
    const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
    switch (env) {
      case 'staging':
        return _stagingApiUrl;
      case 'production':
        return _prodApiUrl;
      default:
        return _devApiUrl;
    }
  }

  /// Check if app is running in debug mode
  static bool get isDebug {
    bool isDebugMode = false;
    assert(isDebugMode = true);
    return isDebugMode;
  }

  /// Check if app is running in production
  static bool get isProduction =>
      const String.fromEnvironment('ENV') == 'production';

  /// Check if app is running in staging
  static bool get isStaging => const String.fromEnvironment('ENV') == 'staging';
}

/// API endpoint constants
class ApiEndpoints {
  // ========== AUTH ==========
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // ========== USER ==========
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // ========== TODOS (Example CRUD) ==========
  static const String todos = '/todos';
  static String todo(String id) => '/todos/$id';

  // ========== UPLOAD ==========
  static const String uploadImage = '/upload/image';
  static const String uploadFile = '/upload/file';
}

/// Error message constants
class ErrorMessages {
  // ========== NETWORK ==========
  static const String noInternetConnection = 'No internet connection available';
  static const String connectionTimeout =
      'Connection timeout. Please try again.';
  static const String serverError =
      'Server error occurred. Please try again later.';
  static const String unknownError = 'An unknown error occurred';

  // ========== VALIDATION ==========
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String nameRequired = 'Name is required';
  static const String nameTooLong = 'Name must be less than 50 characters';

  // ========== AUTH ==========
  static const String loginFailed =
      'Login failed. Please check your credentials.';
  static const String registrationFailed =
      'Registration failed. Please try again.';
  static const String userNotFound = 'User not found';
  static const String userAlreadyExists = 'User with this email already exists';
  static const String invalidCredentials = 'Invalid email or password';
  static const String tokenExpired = 'Session expired. Please login again.';
}

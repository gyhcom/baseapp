import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../data/datasources/local/local_storage.dart';
import '../data/datasources/remote/api_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/todo_usecases.dart';

/// Global service locator instance
final GetIt getIt = GetIt.instance;

/// Setup dependencies manually (alternative to code generation)
Future<void> setupDependencies() async {
  // ========== EXTERNAL DEPENDENCIES ==========

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Hive
  await Hive.initFlutter();
  final hiveBox = await Hive.openBox(AppConstants.hiveBoxName);
  getIt.registerSingleton<Box>(hiveBox);

  // Dio HTTP Client
  final dio = Dio();
  dio.options.baseUrl = AppConstants.apiUrl;
  dio.options.connectTimeout = AppConstants.connectTimeout;
  dio.options.receiveTimeout = AppConstants.receiveTimeout;
  dio.options.sendTimeout = AppConstants.sendTimeout;

  // Add interceptors
  if (AppConstants.isDebug) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  getIt.registerSingleton<Dio>(dio);

  // ========== CORE LAYER ==========

  // API Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // Local Storage
  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(
      sharedPreferences: getIt<SharedPreferences>(),
      hiveBox: getIt<Box>(),
    ),
  );

  // ========== DATA LAYER ==========

  // Remote Data Sources - Use Mock for now
  getIt.registerLazySingleton<ApiService>(
    () => MockApiService(), // Using mock implementation for development
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );

  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      apiService: getIt<ApiService>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );

  // ========== DOMAIN LAYER ==========

  // Auth Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  // Todo Use Cases
  getIt.registerLazySingleton<GetTodosUseCase>(
    () => GetTodosUseCase(getIt<TodoRepository>()),
  );

  getIt.registerLazySingleton<CreateTodoUseCase>(
    () => CreateTodoUseCase(getIt<TodoRepository>()),
  );

  getIt.registerLazySingleton<UpdateTodoUseCase>(
    () => UpdateTodoUseCase(getIt<TodoRepository>()),
  );

  getIt.registerLazySingleton<DeleteTodoUseCase>(
    () => DeleteTodoUseCase(getIt<TodoRepository>()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}

/// Register mock dependencies for testing
Future<void> setupMockDependencies() async {
  // TODO: Implement mock dependencies for testing
  // This will be used in test files to register mock implementations
}

/// Module for feature-specific dependencies
/// Use this pattern to organize dependencies by feature
class AuthModule {
  static void register() {
    // Register auth-specific dependencies
    // This can be called conditionally based on feature flags

    // Example: Register Firebase Auth only if enabled
    if (AppConstants.enableFirebaseAuth) {
      // getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    }
  }
}

class NotificationModule {
  static void register() {
    // Register notification-specific dependencies
    if (AppConstants.enablePushNotifications) {
      // Register push notification services
    }
  }
}

class AnalyticsModule {
  static void register() {
    // Register analytics-specific dependencies
    if (AppConstants.enableAnalytics) {
      // Register analytics services
    }
  }
}

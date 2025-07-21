import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../data/datasources/local/local_storage.dart';
import '../data/datasources/local/routine_local_datasource.dart';
import '../data/datasources/remote/api_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../data/repositories/routine_repository_impl.dart';
import '../data/repositories/usage_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/services/notification_service.dart';
import '../domain/usecases/notification_usecase.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/repositories/routine_repository.dart';
import '../domain/repositories/usage_repository.dart';
import '../domain/entities/user_auth.dart';
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/auth_usecase.dart';
import '../domain/usecases/todo_usecases.dart';
import '../domain/services/auth_service.dart';
import '../data/services/firebase_auth_service.dart';

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

  // Auth Service
  getIt.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(),
  );

  // Auth Box for Hive
  final userAuthBox = await Hive.openBox<UserAuth>('userAuth');
  getIt.registerSingleton<Box<UserAuth>>(userAuthBox, instanceName: 'userAuthBox');

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      localStorage: getIt<LocalStorage>(),
      authService: getIt<AuthService>(),
      userAuthBox: getIt<Box<UserAuth>>(instanceName: 'userAuthBox'),
    ),
  );

  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      apiService: getIt<ApiService>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );

  // 루틴 로컬 데이터소스 초기화 및 등록
  final routineLocalDataSource = RoutineLocalDataSourceImpl();
  await routineLocalDataSource.init();
  getIt.registerSingleton<RoutineLocalDataSource>(routineLocalDataSource);

  // 루틴 저장소
  getIt.registerLazySingleton<RoutineRepository>(
    () => RoutineRepositoryImpl(
      localDataSource: getIt<RoutineLocalDataSource>(),
    ),
  );

  // 사용량 관리 저장소
  getIt.registerLazySingleton<UsageRepository>(
    () => UsageRepositoryImpl(),
  );

  // 알림 저장소
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(),
  );

  // 알림 서비스
  getIt.registerLazySingleton<NotificationService>(
    () => LocalNotificationService(),
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

  // Social Auth Use Case
  getIt.registerLazySingleton<AuthUseCase>(
    () => AuthUseCase(authRepository: getIt<AuthRepository>()),
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

  // 알림 유스케이스
  getIt.registerLazySingleton<NotificationUseCase>(
    () => NotificationUseCase(
      getIt<NotificationRepository>(),
      getIt<NotificationService>(),
    ),
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

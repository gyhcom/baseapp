import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  const Failure({required this.message, this.code, this.details});

  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  List<Object?> get props => [message, code, details];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code, super.details});

  factory ServerFailure.unexpected() => const ServerFailure(
    message: 'An unexpected server error occurred',
    code: 'SERVER_ERROR',
  );

  factory ServerFailure.timeout() => const ServerFailure(
    message: 'Request timeout. Please try again.',
    code: 'TIMEOUT',
  );

  factory ServerFailure.notFound() => const ServerFailure(
    message: 'Requested resource not found',
    code: 'NOT_FOUND',
  );

  factory ServerFailure.unauthorized() => const ServerFailure(
    message: 'Authentication required',
    code: 'UNAUTHORIZED',
  );

  factory ServerFailure.forbidden() =>
      const ServerFailure(message: 'Access forbidden', code: 'FORBIDDEN');
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.details});

  factory NetworkFailure.noConnection() => const NetworkFailure(
    message: 'No internet connection available',
    code: 'NO_CONNECTION',
  );

  factory NetworkFailure.connectionLost() => const NetworkFailure(
    message: 'Connection lost during request',
    code: 'CONNECTION_LOST',
  );

  factory NetworkFailure.unreachable() =>
      const NetworkFailure(message: 'Server unreachable', code: 'UNREACHABLE');
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.details});

  factory CacheFailure.notFound() => const CacheFailure(
    message: 'Data not found in cache',
    code: 'CACHE_NOT_FOUND',
  );

  factory CacheFailure.writeError() => const CacheFailure(
    message: 'Failed to write data to cache',
    code: 'CACHE_WRITE_ERROR',
  );

  factory CacheFailure.readError() => const CacheFailure(
    message: 'Failed to read data from cache',
    code: 'CACHE_READ_ERROR',
  );
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code, super.details});

  factory ValidationFailure.invalidEmail() => const ValidationFailure(
    message: 'Please enter a valid email address',
    code: 'INVALID_EMAIL',
  );

  factory ValidationFailure.weakPassword() => const ValidationFailure(
    message: 'Password must be at least 8 characters long',
    code: 'WEAK_PASSWORD',
  );

  factory ValidationFailure.required(String field) => ValidationFailure(
    message: '$field is required',
    code: 'REQUIRED_FIELD',
    details: {'field': field},
  );
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code, super.details});

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Invalid email or password',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthFailure.userNotFound() =>
      const AuthFailure(message: 'User not found', code: 'USER_NOT_FOUND');

  factory AuthFailure.userAlreadyExists() => const AuthFailure(
    message: 'User with this email already exists',
    code: 'USER_ALREADY_EXISTS',
  );

  factory AuthFailure.tokenExpired() => const AuthFailure(
    message: 'Session expired. Please login again.',
    code: 'TOKEN_EXPIRED',
  );

  factory AuthFailure.emailNotVerified() => const AuthFailure(
    message: 'Please verify your email address',
    code: 'EMAIL_NOT_VERIFIED',
  );
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.code, super.details});

  factory PermissionFailure.denied(String permission) => PermissionFailure(
    message: '$permission permission denied',
    code: 'PERMISSION_DENIED',
    details: {'permission': permission},
  );

  factory PermissionFailure.permanentlyDenied(
    String permission,
  ) => PermissionFailure(
    message:
        '$permission permission permanently denied. Please enable it in settings.',
    code: 'PERMISSION_PERMANENTLY_DENIED',
    details: {'permission': permission},
  );
}

/// General application failures
class AppFailure extends Failure {
  const AppFailure({required super.message, super.code, super.details});

  factory AppFailure.unexpected() => const AppFailure(
    message: 'An unexpected error occurred',
    code: 'UNEXPECTED_ERROR',
  );

  factory AppFailure.featureNotAvailable() => const AppFailure(
    message: 'This feature is not available',
    code: 'FEATURE_NOT_AVAILABLE',
  );

  factory AppFailure.maintenance() => const AppFailure(
    message: 'App is under maintenance. Please try again later.',
    code: 'MAINTENANCE',
  );
}

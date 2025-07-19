import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

/// HTTP API client wrapper around Dio
class ApiClient {
  ApiClient(this._dio) {
    _setupInterceptors();
  }

  final Dio _dio;

  /// Setup interceptors for authentication, logging, etc.
  void _setupInterceptors() {
    // Auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Add common headers
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';

          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token refresh
          if (error.response?.statusCode == 401) {
            if (await _refreshToken()) {
              // Retry the request with new token
              try {
                final token = await _getAuthToken();
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                );
                handler.resolve(response);
                return;
              } catch (e) {
                // Refresh failed, continue with original error
              }
            }
          }

          handler.next(error);
        },
      ),
    );

    // Logging interceptor (only in debug mode)
    if (AppConstants.isDebug) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String? fileName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        ...?data,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Download file
  Future<Response> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to app failures
  Failure _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ServerFailure.timeout();

        case DioExceptionType.connectionError:
          return NetworkFailure.noConnection();

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 401:
              return ServerFailure.unauthorized();
            case 403:
              return ServerFailure.forbidden();
            case 404:
              return ServerFailure.notFound();
            case 500:
            case 502:
            case 503:
            case 504:
              return ServerFailure.unexpected();
            default:
              return ServerFailure(
                message: error.response?.statusMessage ?? 'Server error',
                code: statusCode?.toString(),
              );
          }

        case DioExceptionType.cancel:
          return const AppFailure(
            message: 'Request was cancelled',
            code: 'REQUEST_CANCELLED',
          );

        case DioExceptionType.badCertificate:
          return const NetworkFailure(
            message: 'Certificate verification failed',
            code: 'BAD_CERTIFICATE',
          );

        case DioExceptionType.unknown:
        default:
          return ServerFailure.unexpected();
      }
    }

    return AppFailure.unexpected();
  }

  /// Get stored auth token
  Future<String?> _getAuthToken() async {
    // TODO: Implement token retrieval from secure storage
    // This will be implemented when we add the local storage layer
    return null;
  }

  /// Refresh auth token
  Future<bool> _refreshToken() async {
    // TODO: Implement token refresh logic
    // This will be implemented when we add the auth system
    return false;
  }
}

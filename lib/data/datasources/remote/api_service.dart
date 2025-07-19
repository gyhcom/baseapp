import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/app_constants.dart';

/// Abstract interface for API service operations
abstract class ApiService {
  // ========== AUTH ENDPOINTS ==========
  Future<Response> login({required String email, required String password});

  Future<Response> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Response> logout();

  Future<Response> refreshToken({required String refreshToken});

  Future<Response> forgotPassword({required String email});

  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Response> verifyEmail({required String token});

  // ========== USER ENDPOINTS ==========
  Future<Response> getUserProfile();

  Future<Response> updateUserProfile({required Map<String, dynamic> userData});

  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Response> deleteAccount();

  // ========== TODO ENDPOINTS (Example CRUD) ==========
  Future<Response> getTodos({int? page, int? limit, String? search});

  Future<Response> getTodo({required String id});

  Future<Response> createTodo({
    required String title,
    required String description,
    bool? isCompleted,
  });

  Future<Response> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  });

  Future<Response> deleteTodo({required String id});

  // ========== FILE UPLOAD ENDPOINTS ==========
  Future<Response> uploadImage({
    required String filePath,
    String? fileName,
    ProgressCallback? onProgress,
  });

  Future<Response> uploadFile({
    required String filePath,
    String? fileName,
    ProgressCallback? onProgress,
  });
}

/// Implementation of ApiService using ApiClient
class ApiServiceImpl implements ApiService {
  ApiServiceImpl(this._apiClient);

  final ApiClient _apiClient;

  // ========== AUTH ENDPOINTS ==========

  @override
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  @override
  Future<Response> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _apiClient.post(
      ApiEndpoints.register,
      data: {'email': email, 'password': password, 'name': name},
    );
  }

  @override
  Future<Response> logout() async {
    return await _apiClient.post(ApiEndpoints.logout);
  }

  @override
  Future<Response> refreshToken({required String refreshToken}) async {
    return await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );
  }

  @override
  Future<Response> forgotPassword({required String email}) async {
    return await _apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await _apiClient.post(
      ApiEndpoints.resetPassword,
      data: {'token': token, 'new_password': newPassword},
    );
  }

  @override
  Future<Response> verifyEmail({required String token}) async {
    return await _apiClient.post(
      ApiEndpoints.verifyEmail,
      data: {'token': token},
    );
  }

  // ========== USER ENDPOINTS ==========

  @override
  Future<Response> getUserProfile() async {
    return await _apiClient.get(ApiEndpoints.profile);
  }

  @override
  Future<Response> updateUserProfile({
    required Map<String, dynamic> userData,
  }) async {
    return await _apiClient.put(ApiEndpoints.updateProfile, data: userData);
  }

  @override
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _apiClient.put(
      ApiEndpoints.changePassword,
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }

  @override
  Future<Response> deleteAccount() async {
    return await _apiClient.delete(ApiEndpoints.deleteAccount);
  }

  // ========== TODO ENDPOINTS (Example CRUD) ==========

  @override
  Future<Response> getTodos({int? page, int? limit, String? search}) async {
    final queryParameters = <String, dynamic>{};

    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;
    if (search != null && search.isNotEmpty) queryParameters['search'] = search;

    return await _apiClient.get(
      ApiEndpoints.todos,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
  }

  @override
  Future<Response> getTodo({required String id}) async {
    return await _apiClient.get(ApiEndpoints.todo(id));
  }

  @override
  Future<Response> createTodo({
    required String title,
    required String description,
    bool? isCompleted,
  }) async {
    return await _apiClient.post(
      ApiEndpoints.todos,
      data: {
        'title': title,
        'description': description,
        'is_completed': isCompleted ?? false,
      },
    );
  }

  @override
  Future<Response> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    final data = <String, dynamic>{};

    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (isCompleted != null) data['is_completed'] = isCompleted;

    return await _apiClient.put(ApiEndpoints.todo(id), data: data);
  }

  @override
  Future<Response> deleteTodo({required String id}) async {
    return await _apiClient.delete(ApiEndpoints.todo(id));
  }

  // ========== FILE UPLOAD ENDPOINTS ==========

  @override
  Future<Response> uploadImage({
    required String filePath,
    String? fileName,
    ProgressCallback? onProgress,
  }) async {
    return await _apiClient.uploadFile(
      ApiEndpoints.uploadImage,
      filePath,
      fileName: fileName,
      onSendProgress: onProgress,
    );
  }

  @override
  Future<Response> uploadFile({
    required String filePath,
    String? fileName,
    ProgressCallback? onProgress,
  }) async {
    return await _apiClient.uploadFile(
      ApiEndpoints.uploadFile,
      filePath,
      fileName: fileName,
      onSendProgress: onProgress,
    );
  }
}

/// Mock implementation for testing and development
class MockApiService implements ApiService {
  // ========== AUTH ENDPOINTS ==========

  @override
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock successful login
    if (email == 'test@example.com' && password == 'password123') {
      return Response(
        data: {
          'success': true,
          'data': {
            'access_token': 'mock_access_token',
            'refresh_token': 'mock_refresh_token',
            'user': {'id': '1', 'email': email, 'name': 'Test User'},
          },
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiEndpoints.login),
      );
    }

    // Mock failed login
    return Response(
      data: {'success': false, 'error': 'Invalid credentials'},
      statusCode: 401,
      requestOptions: RequestOptions(path: ApiEndpoints.login),
    );
  }

  @override
  Future<Response> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {
        'success': true,
        'data': {
          'access_token': 'mock_access_token',
          'refresh_token': 'mock_refresh_token',
          'user': {'id': '1', 'email': email, 'name': name},
        },
      },
      statusCode: 201,
      requestOptions: RequestOptions(path: ApiEndpoints.register),
    );
  }

  @override
  Future<Response> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Response(
      data: {'success': true},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.logout),
    );
  }

  @override
  Future<Response> refreshToken({required String refreshToken}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Response(
      data: {
        'success': true,
        'data': {
          'access_token': 'new_mock_access_token',
          'refresh_token': 'new_mock_refresh_token',
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.refreshToken),
    );
  }

  @override
  Future<Response> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {'success': true, 'message': 'Password reset email sent'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.forgotPassword),
    );
  }

  @override
  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {'success': true, 'message': 'Password reset successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.resetPassword),
    );
  }

  @override
  Future<Response> verifyEmail({required String token}) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {'success': true, 'message': 'Email verified successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.verifyEmail),
    );
  }

  // ========== USER ENDPOINTS ==========

  @override
  Future<Response> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Response(
      data: {
        'success': true,
        'data': {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
          'avatar': null,
          'created_at': '2024-01-01T00:00:00Z',
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.profile),
    );
  }

  @override
  Future<Response> updateUserProfile({
    required Map<String, dynamic> userData,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {
        'success': true,
        'data': {
          'id': '1',
          'email': 'test@example.com',
          'name': userData['name'] ?? 'Test User',
          'avatar': userData['avatar'],
          'updated_at': DateTime.now().toIso8601String(),
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.updateProfile),
    );
  }

  @override
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {'success': true, 'message': 'Password changed successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.changePassword),
    );
  }

  @override
  Future<Response> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 2));

    return Response(
      data: {'success': true, 'message': 'Account deleted successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.deleteAccount),
    );
  }

  // ========== TODO ENDPOINTS ==========

  @override
  Future<Response> getTodos({int? page, int? limit, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock todo data
    final todos = List.generate(
      10,
      (index) => {
        'id': '${index + 1}',
        'title': 'Mock Todo ${index + 1}',
        'description': 'This is a mock todo item for testing purposes',
        'is_completed': index % 3 == 0,
        'created_at': DateTime.now()
            .subtract(Duration(days: index))
            .toIso8601String(),
      },
    );

    return Response(
      data: {
        'success': true,
        'data': {
          'todos': todos,
          'pagination': {
            'current_page': page ?? 1,
            'per_page': limit ?? AppConstants.defaultPageSize,
            'total': todos.length,
          },
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.todos),
    );
  }

  @override
  Future<Response> getTodo({required String id}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Response(
      data: {
        'success': true,
        'data': {
          'id': id,
          'title': 'Mock Todo $id',
          'description': 'This is a detailed mock todo item',
          'is_completed': false,
          'created_at': DateTime.now().toIso8601String(),
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.todo(id)),
    );
  }

  @override
  Future<Response> createTodo({
    required String title,
    required String description,
    bool? isCompleted,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {
        'success': true,
        'data': {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': title,
          'description': description,
          'is_completed': isCompleted ?? false,
          'created_at': DateTime.now().toIso8601String(),
        },
      },
      statusCode: 201,
      requestOptions: RequestOptions(path: ApiEndpoints.todos),
    );
  }

  @override
  Future<Response> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {
        'success': true,
        'data': {
          'id': id,
          'title': title ?? 'Mock Todo $id',
          'description': description ?? 'Updated description',
          'is_completed': isCompleted ?? false,
          'updated_at': DateTime.now().toIso8601String(),
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.todo(id)),
    );
  }

  @override
  Future<Response> deleteTodo({required String id}) async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      data: {'success': true, 'message': 'Todo deleted successfully'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.todo(id)),
    );
  }

  // ========== FILE UPLOAD ENDPOINTS ==========

  @override
  Future<Response> uploadImage({
    required String filePath,
    String? fileName,
    ProgressCallback? onProgress,
  }) async {
    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      onProgress?.call(i, 100);
    }

    return Response(
      data: {
        'success': true,
        'data': {
          'url': 'https://example.com/uploads/mock_image.jpg',
          'filename': fileName ?? 'mock_image.jpg',
          'size': 1024,
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.uploadImage),
    );
  }

  @override
  Future<Response> uploadFile({
    required String filePath,
    String? fileName,
    ProgressCallback? onProgress,
  }) async {
    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      onProgress?.call(i, 100);
    }

    return Response(
      data: {
        'success': true,
        'data': {
          'url': 'https://example.com/uploads/mock_file.pdf',
          'filename': fileName ?? 'mock_file.pdf',
          'size': 2048,
        },
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ApiEndpoints.uploadFile),
    );
  }
}

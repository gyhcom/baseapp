import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/local_storage.dart';
import '../datasources/remote/api_service.dart';

/// Implementation of TodoRepository
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({
    required ApiService apiService,
    required LocalStorage localStorage,
  }) : _apiService = apiService,
       _localStorage = localStorage;

  final ApiService _apiService;
  final LocalStorage _localStorage;

  @override
  Future<List<Todo>> getTodos({int? page, int? limit, String? search}) async {
    final response = await _apiService.getTodos(
      page: page,
      limit: limit,
      search: search,
    );

    final data = response.data as Map<String, dynamic>;
    final todosData = data['data'] as Map<String, dynamic>;
    final todosList = todosData['todos'] as List<dynamic>;

    return todosList
        .map((todo) => _mapToTodo(todo as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Todo> getTodo({required String id}) async {
    final response = await _apiService.getTodo(id: id);

    final data = response.data as Map<String, dynamic>;
    final todoData = data['data'] as Map<String, dynamic>;

    return _mapToTodo(todoData);
  }

  @override
  Future<Todo> createTodo({
    required String title,
    required String description,
    bool? isCompleted,
  }) async {
    final response = await _apiService.createTodo(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    final data = response.data as Map<String, dynamic>;
    final todoData = data['data'] as Map<String, dynamic>;

    return _mapToTodo(todoData);
  }

  @override
  Future<Todo> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    final response = await _apiService.updateTodo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    final data = response.data as Map<String, dynamic>;
    final todoData = data['data'] as Map<String, dynamic>;

    return _mapToTodo(todoData);
  }

  @override
  Future<void> deleteTodo({required String id}) async {
    await _apiService.deleteTodo(id: id);
  }

  @override
  Future<Todo> toggleTodo({required String id}) async {
    // First get the current todo to check its status
    final currentTodo = await getTodo(id: id);

    // Toggle the completion status
    return await updateTodo(id: id, isCompleted: !currentTodo.isCompleted);
  }

  @override
  Future<int> getCompletedCount() async {
    final todos = await getTodos();
    return todos.where((todo) => todo.isCompleted).length;
  }

  @override
  Future<int> getPendingCount() async {
    final todos = await getTodos();
    return todos.where((todo) => !todo.isCompleted).length;
  }

  @override
  Future<void> clearCompleted() async {
    final todos = await getTodos();
    final completedTodos = todos.where((todo) => todo.isCompleted);

    for (final todo in completedTodos) {
      await deleteTodo(id: todo.id);
    }
  }

  /// Map API response to Todo entity
  Todo _mapToTodo(Map<String, dynamic> data) {
    return Todo(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      isCompleted: data['is_completed'] as bool? ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : null,
    );
  }
}

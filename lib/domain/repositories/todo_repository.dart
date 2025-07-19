import '../entities/todo.dart';

/// Todo repository interface
abstract class TodoRepository {
  /// Get all todos with optional pagination and search
  Future<List<Todo>> getTodos({int? page, int? limit, String? search});

  /// Get single todo by ID
  Future<Todo> getTodo({required String id});

  /// Create new todo
  Future<Todo> createTodo({
    required String title,
    required String description,
    bool? isCompleted,
  });

  /// Update existing todo
  Future<Todo> updateTodo({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  });

  /// Delete todo by ID
  Future<void> deleteTodo({required String id});

  /// Toggle todo completion status
  Future<Todo> toggleTodo({required String id});

  /// Get completed todos count
  Future<int> getCompletedCount();

  /// Get pending todos count
  Future<int> getPendingCount();

  /// Clear all completed todos
  Future<void> clearCompleted();
}

import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

/// Get todos use case
class GetTodosUseCase {
  GetTodosUseCase(this._repository);

  final TodoRepository _repository;

  Future<List<Todo>> call({int? page, int? limit, String? search}) async {
    return await _repository.getTodos(page: page, limit: limit, search: search);
  }
}

/// Create todo use case
class CreateTodoUseCase {
  CreateTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Todo> call({
    required String title,
    required String description,
    bool? isCompleted,
  }) async {
    return await _repository.createTodo(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}

/// Update todo use case
class UpdateTodoUseCase {
  UpdateTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<Todo> call({
    required String id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    return await _repository.updateTodo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}

/// Delete todo use case
class DeleteTodoUseCase {
  DeleteTodoUseCase(this._repository);

  final TodoRepository _repository;

  Future<void> call({required String id}) async {
    await _repository.deleteTodo(id: id);
  }
}

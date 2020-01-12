import '../../domain/entities/todo.dart';

abstract class ITodosRepository {
  /// Loads todos
  Future<List<Todo>> loadTodos();
  // Persists todos to local disk and the web
  Future saveTodos(List<Todo> todos);
}

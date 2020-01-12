import 'package:todos_repository_core/src/todo_entity.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

import '../domain/entities/todo.dart';
import '../service/exceptions/persistance_exception.dart';
import '../service/interfaces/i_todo_repository.dart';

class TodosRepository implements ITodosRepository {
  final KeyValueStorage localStorage;

  TodosRepository({this.localStorage})
      : _localStorageRepository = LocalStorageRepository(
          localStorage: localStorage,
        );

  final LocalStorageRepository _localStorageRepository;
  @override
  Future<List<Todo>> loadTodos() async {
    try {
      final todoEntities = await _localStorageRepository.loadTodos();
      var todos = <Todo>[];
      for (var todoEntity in todoEntities) {
        todos.add(
          Todo.fromJson(todoEntity.toJson()),
        );
      }
      return todos;
    } catch (e) {
      throw PersistanceException('There is a problem in loading todos : $e');
    }
  }

  @override
  Future saveTodos(List<Todo> todos) {
    try {
      var todosEntities = <TodoEntity>[];
      for (var todo in todos) {
        todosEntities.add(TodoEntity.fromJson(todo.toJson()));
      }

      return _localStorageRepository.saveTodos(todosEntities);
    } catch (e) {
      throw PersistanceException('There is a problem in saving todos : $e');
    }
  }
}

import 'package:todos_repository_core/src/todo_entity.dart';
import 'package:todos_repository_core/src/todos_repository.dart' as core;
import '../domain/entities/todo.dart';
import '../service/exceptions/persistance_exception.dart';
import '../service/interfaces/i_todo_repository.dart';

class StatesRebuilderTodosRepository implements ITodosRepository {
  final core.TodosRepository _todosRepository;

  StatesRebuilderTodosRepository({core.TodosRepository todosRepository})
      : _todosRepository = todosRepository;

  @override
  Future<List<Todo>> loadTodos() async {
    try {
      final todoEntities = await _todosRepository.loadTodos();
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
  Future saveTodos(List<Todo> todos) async {
    try {
      var todosEntities = <TodoEntity>[];
      //// to simulate en error uncomment these lines.
      // await Future.delayed(Duration(milliseconds: 500));
      // throw Exception();
      for (var todo in todos) {
        todosEntities.add(TodoEntity.fromJson(todo.toJson()));
      }
      return _todosRepository.saveTodos(todosEntities);
    } catch (e) {
      throw PersistanceException('There is a problem in saving todos');
    }
  }
}

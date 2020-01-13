import 'package:states_rebuilder_sample/domain/entities/todo.dart';

import 'common/enums.dart';
import 'interfaces/i_todo_repository.dart';

//`TodosService` is a pure dart class that can be easily tested (see test folder).

class TodosService {
  //Constructor injection of the ITodoRepository abstract class.
  TodosService(ITodosRepository todoRepository)
      : _todoRepository = todoRepository;

  //private fields
  final ITodosRepository _todoRepository;
  List<Todo> _todos = const [];

  //public field
  VisibilityFilter activeFilter = VisibilityFilter.all;

  //getters
  List<Todo> get todos {
    if (activeFilter == VisibilityFilter.active) {
      return _activeTodos;
    }
    if (activeFilter == VisibilityFilter.completed) {
      return _completedTodos;
    }
    return _todos;
  }

  List<Todo> get _completedTodos => _todos.where((t) => t.complete).toList();
  List<Todo> get _activeTodos => _todos.where((t) => !t.complete).toList();
  int get numCompleted => _completedTodos.length;
  int get numActive => _activeTodos.length;
  bool get allComplete => _activeTodos.isEmpty;

  //methods for CRUD
  void loadTodos() async {
    _todos = await _todoRepository.loadTodos();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _todoRepository.saveTodos(_todos);
  }

  void updateTodo(Todo todo) {
    final index = _todos.indexOf(todo);
    if (index == -1) return;
    _todos[index] = todo;
    _todoRepository.saveTodos(_todos);
  }

  void deleteTodo(Todo todo) {
    if (_todos.remove(todo)) {
      _todoRepository.saveTodos(_todos);
    }
  }

  void toggleAll() {
    final allComplete = _todos.every((todo) => todo.complete);

    for (final todo in _todos) {
      todo.complete = !allComplete;
    }
    _todoRepository.saveTodos(_todos);
  }

  void clearCompleted() {
    _todos.removeWhere((todo) => todo.complete);
    _todoRepository.saveTodos(_todos);
  }
}

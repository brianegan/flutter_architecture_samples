import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/exceptions/persistance_exception.dart';

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
  Future<void> loadTodos() async {
    // await Future.delayed(Duration(seconds: 5));
    // throw PersistanceException('net work error');
    return _todos = await _todoRepository.loadTodos();
  }

  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await _todoRepository.saveTodos(_todos).catchError((error) {
      _todos.remove(todo);
      throw error;
    });
  }

  //on updating todos, states_rebuilder will instantly update the UI,
  //Meanwhile the asynchronous method saveTodos is executed in the background.
  //If an error occurs, the old state is returned and states_rebuilder update the UI
  //to display the old state and shows a snackBar informing the user of the error.

  Future<void> updateTodo(Todo todo) async {
    final oldTodo = _todos.firstWhere((t) => t.id == todo.id);
    final index = _todos.indexOf(oldTodo);
    _todos[index] = todo;
    //here states_rebuild will update the UI to display the new todos
    await _todoRepository.saveTodos(_todos).catchError((error) {
      //on error return to the initial state
      _todos[index] = oldTodo;
      //for states_rebuild to be informed of the error, we rethrow the error
      throw error;
    });
  }

  Future<void> deleteTodo(Todo todo) async {
    final index = _todos.indexOf(todo);
    _todos.removeAt(index);
    return _todoRepository.saveTodos(_todos).catchError((error) {
      //on error reinsert the deleted todo
      _todos.insert(index, todo);
      throw error;
    });
  }

  Future<void> toggleAll() async {
    final allComplete = _todos.every((todo) => todo.complete);
    var beforeTodos = <Todo>[];

    for (var i = 0; i < _todos.length; i++) {
      beforeTodos.add(_todos[i]);
      _todos[i] = _todos[i].copyWith(complete: !allComplete);
    }
    return _todoRepository.saveTodos(_todos).catchError(
      (error) {
        //on error return to the initial state
        _todos = beforeTodos;
        throw error;
      },
    );
  }

  Future<void> clearCompleted() async {
    var beforeTodos = List<Todo>.from(_todos);
    _todos.removeWhere((todo) => todo.complete);
    await _todoRepository.saveTodos(_todos).catchError(
      (error) {
        //on error return to the initial state
        _todos = beforeTodos;
        throw error;
      },
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:states_rebuilder_sample/domain/entities/todo.dart';

import 'common/enums.dart';
import 'interfaces/i_todo_repository.dart';

//`TodosState` is a pure dart immutable class that can be easily tested (see test folder).
@immutable
class TodosState {
  //Constructor injection of the ITodoRepository abstract class.
  TodosState({
    ITodosRepository todoRepository,
    List<Todo> todos,
    VisibilityFilter activeFilter,
  })  : _todoRepository = todoRepository,
        _todos = todos,
        _activeFilter = activeFilter;

  //private fields
  final ITodosRepository _todoRepository;
  final List<Todo> _todos;
  final VisibilityFilter _activeFilter;

  //public getters
  List<Todo> get todos {
    if (_activeFilter == VisibilityFilter.active) {
      return _activeTodos;
    }
    if (_activeFilter == VisibilityFilter.completed) {
      return _completedTodos;
    }
    return _todos;
  }

  int get numCompleted => _completedTodos.length;
  int get numActive => _activeTodos.length;
  bool get allComplete => _activeTodos.isEmpty;
  //private getter
  List<Todo> get _completedTodos => _todos.where((t) => t.complete).toList();
  List<Todo> get _activeTodos => _todos.where((t) => !t.complete).toList();

  //methods for CRUD

  //When we want to await for the future and display something in the screen,
  //we use future.
  Future<TodosState> loadTodos() async {
    ////If you want to simulate loading failure uncomment theses lines
    // await Future.delayed(Duration(seconds: 5));
    // throw PersistanceException('net work error');
    final _todos = await _todoRepository.loadTodos();
    return copyWith(
      todos: _todos,
      activeFilter: VisibilityFilter.all,
    );
  }

  //We use stream generator when we want to instantly display the update, and execute the the saveTodos in the background,
  //and if the saveTodos fails we want to display the old state and a snackbar containing the error message
  Stream<TodosState> addTodo(Todo todo) async* {
    final newTodos = List<Todo>.from(_todos)..add(todo);
    //_saveTodos is common to all crud operation
    yield* _saveTodos(newTodos);
  }

  Stream<TodosState> updateTodo(Todo todo) async* {
    final newTodos = _todos.map((t) => t.id == todo.id ? todo : t).toList();
    yield* _saveTodos(newTodos);
  }

  Stream<TodosState> deleteTodo(Todo todo) async* {
    final newTodos = List<Todo>.from(_todos)..remove(todo);
    yield* _saveTodos(newTodos);
  }

  Stream<TodosState> toggleAll() async* {
    final newTodos = _todos
        .map(
          (t) => t.copyWith(complete: !allComplete),
        )
        .toList();
    yield* _saveTodos(newTodos);
  }

  Stream<TodosState> clearCompleted() async* {
    final newTodos = List<Todo>.from(_todos)
      ..removeWhere(
        (t) => t.complete,
      );
    yield* _saveTodos(newTodos);
  }

  Stream<TodosState> _saveTodos(List<Todo> newTodos) async* {
    //Yield the new state, and states_rebuilder will rebuild observer widgets
    yield copyWith(
      todos: newTodos,
    );
    try {
      await _todoRepository.saveTodos(newTodos);
    } catch (e) {
      //on error yield the old state, states_rebuilder will rebuild the UI to display the old state
      yield this;
      //rethrow the error so that states_rebuilder can display the snackbar containing the error message
      rethrow;
    }
  }

  TodosState copyWith({
    ITodosRepository todoRepository,
    List<Todo> todos,
    VisibilityFilter activeFilter,
  }) {
    final filter = todos?.isEmpty == true ? VisibilityFilter.all : activeFilter;
    return TodosState(
      todoRepository: todoRepository ?? _todoRepository,
      todos: todos ?? _todos,
      activeFilter: filter ?? _activeFilter,
    );
  }

  @override
  String toString() =>
      'TodosState(_todoRepository: $_todoRepository, _todos: $_todos, activeFilter: $_activeFilter)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TodosState &&
        o._todoRepository == _todoRepository &&
        listEquals(o._todos, _todos) &&
        o._activeFilter == _activeFilter;
  }

  @override
  int get hashCode =>
      _todoRepository.hashCode ^ _todos.hashCode ^ _activeFilter.hashCode;
}

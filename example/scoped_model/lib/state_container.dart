import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todos_repository/todos_repository.dart';

class StateContainer extends Model {
  final AppState state;
  final TodosRepository repository;

  StateContainer({
    @required this.state,
    @required this.repository,
  });

  void setTodos(List<Todo> todos) {
    updateState(() {
      state.todos = todos;
      state.isLoading = false;
    });
  }

  void setLoading(bool isLoading) {
    updateState(() {
      state.isLoading = isLoading;
    });
  }

  void toggleAll() {
    updateState(() {
      state.toggleAll();
    });
  }

  void clearCompleted() {
    updateState(() {
      state.clearCompleted();
    });
  }

  void addTodo(Todo todo) {
    updateState(() {
      state.todos.add(todo);
    });
  }

  void removeTodo(Todo todo) {
    updateState(() {
      state.todos.remove(todo);
    });
  }

  void updateFilter(VisibilityFilter filter) {
    updateState(() {
      state.activeFilter = filter;
    });
  }

  void updateTodo(
    Todo todo, {
    bool complete,
    String id,
    String note,
    String task,
  }) {
    updateState(() {
      todo.complete = complete ?? todo.complete;
      todo.id = id ?? todo.id;
      todo.note = note ?? todo.note;
      todo.task = task ?? todo.task;
    });
  }

  void updateState(Function updates) {
    updates();

    notifyListeners();

    repository.saveTodos(state.todos.map((todo) => todo.toEntity()).toList());
  }
}

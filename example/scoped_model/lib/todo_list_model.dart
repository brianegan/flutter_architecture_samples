import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:todos_repository/src/repository.dart';

class TodoListModel extends Model {
  final TodosRepository repository;

  VisibilityFilter _activeFilter;

  VisibilityFilter get activeFilter => _activeFilter;

  set activeFilter(VisibilityFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  List<TodoModel> get todos => _todos.toList();

  List<TodoModel> _todos = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  TodoListModel({@required this.repository, VisibilityFilter activeFilter})
      : this._activeFilter = activeFilter ?? VisibilityFilter.all;

  /// Wraps [ModelFinder.of] for this [Model]. See [ModelFinder.of] for more
  static TodoListModel of(BuildContext context) =>
      new ModelFinder<TodoListModel>().of(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    // update data for every new subscriber, especially for the first one
    loadTodos();
  }

  /// Loads remote data
  ///
  /// Call this initially and when the user manually refreshes
  Future loadTodos() {
    _isLoading = true;
    notifyListeners();

    return repository.loadTodos().then((loadedTodos) {
      _todos = loadedTodos.map(TodoModel.fromEntity).toList();
      _todos.forEach((todo) => todo.addListener(_uploadItems));
      _isLoading = false;
      notifyListeners();
    }).catchError((err) {
      _todos.forEach((todo) => todo.removeListener(_uploadItems));
      _isLoading = false;
      _todos = [];
      notifyListeners();
    });
  }

  List<TodoModel> get filteredTodos => _todos.where((todo) {
        if (activeFilter == VisibilityFilter.all) {
          return true;
        } else if (activeFilter == VisibilityFilter.active) {
          return !todo.complete;
        } else if (activeFilter == VisibilityFilter.completed) {
          return todo.complete;
        }
      }).toList();

  void clearCompleted() {
    _todos.removeWhere((todo) => todo.complete);
    notifyListeners();
  }

  void toggleAll() {
    var allComplete = todos.every((todo) => todo.complete);
    _todos.forEach((todo) {
      todo.complete = !allComplete;
    });
    notifyListeners();
    _uploadItems();
  }

  void removeTodo(TodoModel todo) {
    _todos.remove(todo);
    todo.removeListener(_uploadItems);
    notifyListeners();
    _uploadItems();
  }

  void addTodo(TodoModel todo) {
    _todos.add(todo);
    todo.addListener(_uploadItems);
    notifyListeners();
    _uploadItems();
  }

  void _uploadItems() {
    repository.saveTodos(_todos.map((it) => it.toEntity()).toList());
  }

  TodoModel todoById(String id) {
    return _todos.firstWhere((it) => it.id == id, orElse: () => null);
  }
}

enum VisibilityFilter { all, active, completed }

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:freeze_provider_value_notifier/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'todo_list_model.freezed.dart';

enum VisibilityFilter { all, active, completed }

@immutable
abstract class TodoList with _$TodoList {
  factory TodoList(
    List<Todo> todos, {
    @required VisibilityFilter filter,
    @required bool loading,
  }) = TodoListState;
}

extension TodoListStateExtensions on TodoList {
  List<Todo> get filteredTodos {
    return todos.where((todo) {
      switch (filter) {
        case VisibilityFilter.active:
          return !todo.complete;
        case VisibilityFilter.completed:
          return todo.complete;
        case VisibilityFilter.all:
        default:
          return true;
      }
    }).toList();
  }

  int get numCompleted => todos.where((Todo todo) => todo.complete).toList().length;

  bool get hasCompleted => numCompleted > 0;

  int get numActive => todos.where((Todo todo) => !todo.complete).toList().length;

  bool get hasActiveTodos => numActive > 0;

  Todo todoById(String id) => todos.firstWhere((it) => it.id == id, orElse: () => null);
}

class TodoListController extends ValueNotifier<TodoList> {
  TodoListController({
    VisibilityFilter filter = VisibilityFilter.all,
    @required this.todosRepository,
    List<Todo> todos = const [],
  })  : assert(todosRepository != null),
        super(TodoList(todos, filter: filter, loading: false)) {
    _loadTodos();
  }

  final TodosRepository todosRepository;

  set filter(VisibilityFilter filter) => setState(value.copyWith(filter: filter));

  void setState(TodoList state) {
    if (!const DeepCollectionEquality().equals(state.todos, value.todos)) {
      todosRepository.saveTodos(state.todos.map((it) => it.toEntity()).toList());
    }
    value = state;
  }

  Future<void> _loadTodos() async {
    setState(value.copyWith(loading: true));

    try {
      final todos = await todosRepository.loadTodos();
      setState(value.copyWith(todos: todos.map(Todo.fromEntity).toList(), loading: false));
    } catch (_) {
      setState(value.copyWith(loading: false));
    }
  }

  void addTodo(Todo todo) {
    setState(
      value.copyWith(todos: [...value.todos, todo]),
    );
  }

  void updateTodo(Todo updatedTodo) {
    setState(
      value.copyWith(todos: [
        for (final todo in value.todos) if (todo.id == updatedTodo.id) updatedTodo else todo,
      ]),
    );
  }

  void removeTodoWithId(String id) {
    setState(
      value.copyWith(todos: [
        for (final todo in value.todos) if (todo.id != id) todo,
      ]),
    );
  }

  void toggleAll() {
    final allComplete = value.todos.every((todo) => todo.complete);
    setState(
      value.copyWith(todos: [
        for (final todo in value.todos) todo.copy(complete: !allComplete),
      ]),
    );
  }

  void clearCompleted() {
    setState(
      value.copyWith(
        todos: value.todos.where((todo) => !todo.complete).toList(),
      ),
    );
  }
}

// class _TodoListModel extends ChangeNotifier {
//   final TodosRepository repository;

//   VisibilityFilter _filter;

//   VisibilityFilter get filter => _filter;

//   set filter(VisibilityFilter filter) {
//     _filter = filter;
//     notifyListeners();
//   }

//   List<Todo> _todos;

//   UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

//   bool _isLoading = false;

//   bool get isLoading => _isLoading;

//   _TodoListModel({
//     @required this.repository,
//     VisibilityFilter filter,
//     List<Todo> todos,
//   })  : _todos = todos ?? [],
//         _filter = filter ?? VisibilityFilter.all;

//   @override
//   void addListener(VoidCallback listener) {
//     super.addListener(listener);
//     // update data for every subscriber, especially for the first one
//     loadTodos();
//   }

//   /// Loads remote data
//   ///
//   /// Call this initially and when the user manually refreshes
//   Future loadTodos() {
//     _isLoading = true;
//     notifyListeners();

//     return repository.loadTodos().then((loadedTodos) {
//       _todos.addAll(loadedTodos.map(Todo.fromEntity));
//       _isLoading = false;
//       notifyListeners();
//     }).catchError((err) {
//       _isLoading = false;
//       notifyListeners();
//     });
//   }

//   List<Todo> get filteredTodos {
//     return _todos.where((todo) {
//       switch (filter) {
//         case VisibilityFilter.active:
//           return !todo.complete;
//         case VisibilityFilter.completed:
//           return todo.complete;
//         case VisibilityFilter.all:
//         default:
//           return true;
//       }
//     }).toList();
//   }

//   void clearCompleted() {
//     _todos.removeWhere((todo) => todo.complete);
//     notifyListeners();
//     _uploadItems();
//   }

//   void toggleAll() {
//     var allComplete = todos.every((todo) => todo.complete);
//     _todos = _todos.map((todo) => todo.copy(complete: !allComplete)).toList();
//     notifyListeners();
//     _uploadItems();
//   }

//   /// updates a [Todo] by replacing the item with the same id by the parameter [todo]
//   void updateTodo(Todo todo) {
//     assert(todo != null);
//     assert(todo.id != null);
//     var oldTodo = _todos.firstWhere((it) => it.id == todo.id);
//     var replaceIndex = _todos.indexOf(oldTodo);
//     _todos.replaceRange(replaceIndex, replaceIndex + 1, [todo]);
//     notifyListeners();
//     _uploadItems();
//   }

//   void removeTodo(Todo todo) {
//     _todos.removeWhere((it) => it.id == todo.id);
//     notifyListeners();
//     _uploadItems();
//   }

//   void addTodo(Todo todo) {
//     _todos.add(todo);
//     notifyListeners();
//     _uploadItems();
//   }

//   void _uploadItems() {
//     repository.saveTodos(_todos.map((it) => it.toEntity()).toList());
//   }

//   Todo todoById(String id) {
//     return _todos.firstWhere((it) => it.id == id, orElse: () => null);
//   }

//   int get numCompleted => todos.where((Todo todo) => todo.complete).toList().length;

//   bool get hasCompleted => numCompleted > 0;

//   int get numActive => todos.where((Todo todo) => !todo.complete).toList().length;

//   bool get hasActiveTodos => numActive > 0;
// }

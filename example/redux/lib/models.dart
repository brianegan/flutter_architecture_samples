import 'package:flutter/foundation.dart';
import 'package:flutter_architecture_samples/uuid.dart';

enum AppTab { todos, stats }

enum ExtraAction { toggleAllComplete, clearCompleted }

enum VisibilityFilter { all, active, completed }

@immutable
class AppState {
  final bool isLoading;
  final List<Todo> todos;
  final AppTab activeTab;
  final VisibilityFilter activeFilter;
  final Function() myFn;

  AppState(
      {this.isLoading = false,
      this.todos = const [],
      this.activeTab = AppTab.todos,
      this.activeFilter = VisibilityFilter.all,
      this.myFn});

  factory AppState.loading() => new AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<Todo> todos,
    AppTab activeTab,
    VisibilityFilter activeFilter,
  }) {
    myFn();

    return new AppState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  bool get allComplete => todos.every((todo) => todo.complete);

  List<Todo> filteredTodos(VisibilityFilter activeFilter) =>
      todos.where((todo) {
        if (activeFilter == VisibilityFilter.all) {
          return true;
        } else if (activeFilter == VisibilityFilter.active) {
          return !todo.complete;
        } else if (activeFilter == VisibilityFilter.completed) {
          return todo.complete;
        }
      }).toList();

  bool get hasCompletedTodos => todos.any((todo) => todo.complete);

  int get numActive =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

  int get numCompleted =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  @override
  int get hashCode =>
      isLoading.hashCode ^
      todos.hashCode ^
      activeTab.hashCode ^
      activeFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          todos == other.todos &&
          activeTab == other.activeTab &&
          activeFilter == other.activeFilter;

  Map<String, Object> toJson() {
    return {
      "todos": todos.map((todo) => todo.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, todos: $todos, activeTab: $activeTab, activeFilter: $activeFilter}';
  }

  static AppState fromJson(Map<String, Object> json) {
    final todos = (json["todos"] as List<Map<String, Object>>)
        .map((todoJson) => Todo.fromJson(todoJson))
        .toList();

    return new AppState(
      todos: todos,
    );
  }
}

@immutable
class Todo {
  static const _notFound = "!!__NOT_FOUND__!!";

  final bool complete;
  final String id;
  final String note;
  final String task;

  Todo(this.task, {this.complete = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id ?? new Uuid().generateV4();

  factory Todo.notFound() => new Todo(_notFound);

  Todo copyWith({bool complete, String id, String note, String task}) {
    return new Todo(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  bool get isNotFound => this.task == _notFound;

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
      "id": id,
    };
  }

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  static Todo fromJson(Map<String, Object> json) {
    return new Todo(
      json["task"] as String,
      complete: json["complete"] as bool,
      note: json["note"] as String,
      id: json["id"] as String,
    );
  }
}

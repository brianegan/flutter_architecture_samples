import 'dart:math';

class AppState {
  final List<Todo> todos;
  final VisibilityFilter activeFilter;
  final bool isLoading;
  final AppTab activeTab;

  AppState({
    this.todos = const [],
    this.activeFilter = VisibilityFilter.all,
    this.isLoading = false,
    this.activeTab = AppTab.todos,
  });

  factory AppState.loading(List<Todo> todos, VisibilityFilter activeFilter) =>
      new AppState(
        todos: todos,
        activeFilter: activeFilter,
        isLoading: true,
      );

  AppState copyWith({
    List<Todo> todos,
    VisibilityFilter activeFilter,
    bool isLoading,
    AppTab activeTab,
  }) =>
      new AppState(
        todos: todos ?? this.todos,
        activeFilter: activeFilter ?? this.activeFilter,
        isLoading: isLoading ?? this.isLoading,
        activeTab: activeTab ?? this.activeTab,
      );

  AppState toggleAll() {
    final allCompleted = this.allComplete;

    return copyWith(
      todos:
          todos.map((todo) => todo.copyWith(complete: !allCompleted)).toList(),
    );
  }

  AppState toggleOne(Todo todo, bool isComplete) {
    return copyWith(
      todos: todos
          .map((t) => t == todo ? t.copyWith(complete: isComplete) : t)
          .toList(),
    );
  }

  AppState clearCompleted() =>
      copyWith(todos: todos.where((todo) => !todo.complete).toList());

  bool get hasTodos => todos.isNotEmpty;

  bool get allComplete => todos.every((todo) => todo.complete);

  bool get allActive => todos.every((todo) => !todo.complete);

  bool get hasCompletedTodos => !allActive;

  int get numCompleted =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  int get numActive =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

  List<Todo> get filteredTodos => todos.where((todo) {
        if (activeFilter == VisibilityFilter.all) {
          return true;
        } else if (activeFilter == VisibilityFilter.active) {
          return !todo.complete;
        } else if (activeFilter == VisibilityFilter.completed) {
          return todo.complete;
        }
      }).toList();

  Map<String, Object> toJson() {
    return {
      "todos": todos.map((todo) => todo.toJson()).toList(),
      "activeFilter": activeFilter.toString(),
      "activeTab": activeTab.toString(),
    };
  }

  static AppState fromJson(Map<String, Object> json) {
    final todos = (json["todos"] as List<Map<String, Object>>)
        .map((todoJson) => Todo.fromJson(todoJson))
        .toList();
    final activeFilter = getFilterFromString(json["activeFilter"] as String);
    final activeTab = getTabFromString(json["activeTab"] as String);

    return new AppState(
        todos: todos, activeFilter: activeFilter, activeTab: activeTab);
  }

  static VisibilityFilter getFilterFromString(String activeFilterAsString) {
    for (VisibilityFilter activeFilter in VisibilityFilter.values) {
      if (activeFilter.toString() == activeFilterAsString) {
        return activeFilter;
      }
    }

    return VisibilityFilter.all;
  }

  static AppTab getTabFromString(String tabAsString) {
    for (AppTab tab in AppTab.values) {
      if (tab.toString() == tabAsString) {
        return tab;
      }
    }

    return AppTab.todos;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          todos == other.todos &&
          activeFilter == other.activeFilter &&
          isLoading == other.isLoading &&
          activeTab == other.activeTab;

  @override
  int get hashCode =>
      todos.hashCode ^
      activeFilter.hashCode ^
      isLoading.hashCode ^
      activeTab.hashCode;

  @override
  String toString() {
    return 'AppState{todos: $todos, activeFilter: $activeFilter, isLoading: $isLoading, activeTab: $activeTab}';
  }

  AppState addTodo(Todo todo) {
    return copyWith(
        todos: ([]
          ..addAll(todos)
          ..add(todo)));
  }

  AppState updateTodo(Todo old, Todo replacement) {
    return copyWith(
        todos: todos.map((todo) => todo == old ? replacement : todo).toList());
  }

  AppState removeTodo(Todo todoToRemove) {
    return copyWith(
        todos: todos.where((todo) => todo != todoToRemove).toList());
  }
}

class Todo {
  final bool complete;
  final String task;
  final String note;
  final String id;

  Todo(this.task, {this.complete = false, this.note = '', String id})
      : this.id = id ?? (new Uuid().generateV4());

  Todo copyWith({
    String task,
    bool complete,
    String note,
    String id,
  }) =>
      new Todo(task ?? this.task,
          complete: complete ?? this.complete,
          note: note ?? this.note,
          id: id ?? this.id);

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
      "id": id,
    };
  }

  static Todo fromJson(Map<String, Object> json) {
    return new Todo(
      json["task"] as String,
      complete: json["complete"] as bool,
      note: json["note"] as String,
      id: json["id"] as String,
    );
  }

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;
}

/// A UUID generator. This will generate unique IDs in the format:
///
///     f47ac10b-58cc-4372-a567-0e02b2c3d479
///
/// The generated uuids are 128 bit numbers encoded in a specific string format.
///
/// For more information, see
/// http://en.wikipedia.org/wiki/Universally_unique_identifier.
class Uuid {
  final Random _random = new Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

enum AppTab { todos, stats }

enum VisibilityFilter { all, active, completed }

enum ExtraAction { toggleAllComplete, clearCompleted }

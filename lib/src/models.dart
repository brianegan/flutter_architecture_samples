class AppState {
  List<Todo> todos;
  VisibilityFilter filter;
  bool isLoading;

  AppState([
    this.todos = const [],
    this.filter = VisibilityFilter.all,
    this.isLoading = false,
  ]);

  factory AppState.loading(List<Todo> todos, VisibilityFilter filter) =>
      new AppState(todos, filter, true);

  bool get hasTodos => todos.isNotEmpty;

  bool get allCompleted => todos.every((todo) => todo.complete);

  List<Todo> get filteredTodos => todos.where((todo) {
        if (filter == VisibilityFilter.all) {
          return true;
        } else if (filter == VisibilityFilter.active) {
          return !todo.complete;
        } else if (filter == VisibilityFilter.completed) {
          return todo.complete;
        }
      }).toList();

  @override
  String toString() {
    return 'AppState{\n  todos: $todos,\n  filter: $filter\n}';
  }

  Map<String, Object> toJson() {
    return {
      "todos": todos.map((todo) => todo.toJson()).toList(),
      "filter": filter.toString(),
    };
  }

  static AppState fromJson(Map<String, Object> json) {
    final todos = (json["todos"] as List<Map<String, Object>>)
        .map((todoJson) => Todo.fromJson(todoJson))
        .toList();
    final filter = getFilterFromString(json["filter"] as String);

    return new AppState(todos, filter);
  }

  static VisibilityFilter getFilterFromString(String filterAsString) {
    for (VisibilityFilter filter in VisibilityFilter.values) {
      if (filter.toString() == filterAsString) {
        return filter;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          todos == other.todos &&
          filter == other.filter;

  @override
  int get hashCode => todos.hashCode ^ filter.hashCode;
}

class Todo {
  bool complete;
  bool editing;
  String text;

  Todo(
    this.text, {
    this.complete = false,
    this.editing = false,
  });

  @override
  String toString() {
    return 'Todo{\n  complete: $complete,\n  editing: $editing,\n  text: $text\n}';
  }

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "editing": editing,
      "text": text,
    };
  }

  static Todo fromJson(Map<String, Object> json) {
    return new Todo(
      json["text"] as String,
      complete: json["complete"] as bool,
      editing: json["editing"] as bool,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          editing == other.editing &&
          text == other.text;

  @override
  int get hashCode => complete.hashCode ^ editing.hashCode ^ text.hashCode;
}

enum VisibilityFilter { all, active, completed }

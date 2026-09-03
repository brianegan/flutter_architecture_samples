import 'todo.dart';

enum VisibilityFilter { all, active, completed }

class TodoListState {
  final VisibilityFilter filter;
  final bool isLoading;
  final List<Todo> todos;

  const TodoListState({
    this.filter = VisibilityFilter.all,
    this.isLoading = false,
    this.todos = const [],
  });

  List<Todo> get activeTodos =>
      todos.where((todo) => !todo.complete).toList(growable: false);

  List<Todo> get completedTodos =>
      todos.where((todo) => todo.complete).toList(growable: false);

  bool get hasActiveTodos => activeTodos.isNotEmpty;

  int get numActive => activeTodos.length;

  int get numCompleted => completedTodos.length;

  Todo? todoById(String id) {
    for (final todo in todos) {
      if (todo.id == id) return todo;
    }
    return null;
  }

  List<Todo> get visibleTodos {
    return switch (filter) {
      VisibilityFilter.active => activeTodos,
      VisibilityFilter.completed => completedTodos,
      VisibilityFilter.all => todos,
    };
  }

  TodoListState copyWith({
    VisibilityFilter? filter,
    bool? isLoading,
    List<Todo>? todos,
  }) {
    return TodoListState(
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      todos: todos == null ? this.todos : List.unmodifiable(todos),
    );
  }
}

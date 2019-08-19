import 'package:mobx/mobx.dart';
import 'package:mobx_sample/model/todo.dart';
import 'package:mobx_sample/model/todo_service.dart';

part 'todo_list.g.dart';

class TodoList = _TodoList with _$TodoList;

enum AppTab { todos, stats }

enum VisibilityFilter { all, pending, completed }

enum ListAction { markAllComplete, clearCompleted }

abstract class _TodoList with Store {
  _TodoList() {
    _setup();
  }

  final TodoService _service = TodoService();

  Function _undoOperation;

  @observable
  VisibilityFilter filter = VisibilityFilter.all;

  @observable
  ObservableFuture<void> loader;

  @computed
  List<Todo> get pendingTodos =>
      todos.where((t) => t.done == false).toList(growable: false);

  @computed
  List<Todo> get completedTodos =>
      todos.where((t) => t.done == true).toList(growable: false);

  @computed
  bool get hasCompletedTodos => completedTodos.length > 0;

  @computed
  bool get hasPendingTodos => pendingTodos.length > 0;

  @computed
  List<Todo> get visibleTodos {
    switch (filter) {
      case VisibilityFilter.all:
        return todos;
      case VisibilityFilter.pending:
        return pendingTodos;
      case VisibilityFilter.completed:
        return completedTodos;
    }

    return null;
  }

  final ObservableList<Todo> todos = ObservableList<Todo>();

  @action
  void addTodo(Todo todo) {
    todos.add(todo);
  }

  @action
  void removeTodo(Todo todo) {
    todos.remove(todo);

    _undoOperation = () {
      addTodo(todo);
    };
  }

  applyUndo() {
    if (_undoOperation == null) return;

    _undoOperation();
  }

  @action
  Future<void> _loadTodos() async {
    todos.addAll(await _service.load());
  }

  @action
  void changeFilter(VisibilityFilter value) {
    filter = value;
  }

  @action
  void markAllComplete() {
    todos.forEach((todo) => todo.done = true);
  }

  @action
  void clearCompleted() {
    todos.removeWhere((todo) => todo.done == true);
  }

  void _setup() {
    loader = ObservableFuture(_loadTodos());
  }
}

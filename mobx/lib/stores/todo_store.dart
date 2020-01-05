import 'package:mobx/mobx.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:mobx_sample/models/todo_codec.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'todo_store.g.dart';

/// A reactive class that manages a list of Todos. It provides the ability to
/// add, remove and filter todos.
///
/// The TodoStore interacts with a TodosRepository to load and persist todos. It
/// persists changes every time the list of todos is edited.
class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  _TodoStore(
    this.repository, {
    ObservableList<Todo> todos,
    this.filter = VisibilityFilter.all,
    this.todosCodec = const TodoCodec(),
    this.saveDelay = 500,
  }) : todos = todos ?? ObservableList<Todo>();

  final TodoCodec todosCodec;
  final TodosRepository repository;
  final int saveDelay;
  final ObservableList<Todo> todos;
  ReactionDisposer _disposeSaveReaction;

  @observable
  VisibilityFilter filter;

  @observable
  ObservableFuture<void> loader;

  @computed
  List<Todo> get pendingTodos =>
      todos.where((t) => !t.complete).toList(growable: false);

  @computed
  List<Todo> get completedTodos =>
      todos.where((t) => t.complete).toList(growable: false);

  @computed
  bool get hasCompletedTodos => completedTodos.isNotEmpty;

  @computed
  bool get hasPendingTodos => pendingTodos.isNotEmpty;

  @computed
  int get numPending => pendingTodos.length;

  @computed
  int get numCompleted => completedTodos.length;

  @computed
  List<Todo> get visibleTodos {
    switch (filter) {
      case VisibilityFilter.pending:
        return pendingTodos;
      case VisibilityFilter.completed:
        return completedTodos;
      case VisibilityFilter.all:
      default:
        return todos;
    }
  }

  @action
  void toggleAll() {
    final allComplete = todos.every((todo) => todo.complete);

    for (final todo in todos) {
      todo.complete = !allComplete;
    }
  }

  @action
  void clearCompleted() => todos.removeWhere((todo) => todo.complete);

  @action
  Future<void> _loadTodos() async {
    final entities = await repository.loadTodos();

    todos.addAll(entities.map(todosCodec.decode).toList());
  }

  Future<void> init() async {
    // Load items from the repository when the app starts
    loader = ObservableFuture(_loadTodos());

    await loader;

    // Use `reaction` from mobx.dart to observe the list of todos and persist
    // them to the repository whenever a change occurs.
    //
    // Save operations are debounced by a configurable delay to prevent writing
    // to the repository more often than necessary. In production, save
    // operations are debounced by 500ms. In tests, they are not debounced to
    // speed up test execution.
    _disposeSaveReaction = reaction<List<TodoEntity>>(
      (_) => todos.map(todosCodec.encode).toList(growable: false),
      (todos) => repository.saveTodos(todos),
      delay: saveDelay,
    );
  }

  void dispose() => _disposeSaveReaction();
}

enum VisibilityFilter { all, pending, completed }

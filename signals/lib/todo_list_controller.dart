import 'package:signals/signals.dart';
import 'package:signals_sample/todo.dart';
import 'package:signals_sample/todo_codec.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

enum VisibilityFilter { all, active, completed }

class TodoListController {
  TodoListController({
    required TodosRepository todosRepository,
    VisibilityFilter? filter,
    List<Todo>? todos,
    TodoCodec? codec,
  }) : _todosRepository = todosRepository,
       _todoCodec = codec ?? const TodoCodec(),
       todos = ListSignal(todos ?? []),
       filter = Signal(VisibilityFilter.all);

  final TodosRepository _todosRepository;
  final TodoCodec _todoCodec;
  final ListSignal<Todo> todos;
  final Signal<VisibilityFilter> filter;

  late final EffectCleanup _effectCleanup;
  late final Future<void> initializingFuture;

  ReadonlySignal<List<Todo>> get pendingTodos => Computed(
    () => todos.where((t) => !t.complete.value).toList(growable: false),
  );

  ReadonlySignal<List<Todo>> get completedTodos => Computed(
    () => todos.where((t) => t.complete.value).toList(growable: false),
  );

  ReadonlySignal<bool> get hasCompletedTodos =>
      Computed(() => completedTodos.value.isNotEmpty);

  ReadonlySignal<bool> get hasPendingTodos =>
      Computed(() => pendingTodos.value.isNotEmpty);

  ReadonlySignal<int> get numPending =>
      Computed(() => pendingTodos.value.length);

  ReadonlySignal<int> get numCompleted =>
      Computed(() => completedTodos.value.length);

  ReadonlySignal<List<Todo>> get visibleTodos => Computed(
    () => switch (filter.value) {
      VisibilityFilter.active => pendingTodos.value,
      VisibilityFilter.completed => completedTodos.value,
      VisibilityFilter.all => todos,
    },
  );

  void toggleAll() {
    final allComplete = todos.every((todo) => todo.complete.value);

    for (final todo in todos) {
      todo.complete.value = !allComplete;
    }
  }

  void clearCompleted() => todos.removeWhere((todo) => todo.complete.value);

  Future<void> _loadTodos() async {
    final entities = await _todosRepository.loadTodos();

    todos.addAll(entities.map(_todoCodec.decode).toList());
  }

  Future<void> init() async {
    initializingFuture = _loadTodos();

    await initializingFuture;

    // Use `effect` from signals.dart to observe the list of todos and persist
    // them to the repository whenever a change occurs.
    //
    // Save operations are debounced by a configurable delay to prevent writing
    // to the repository more often than necessary. In production, save
    // operations are debounced by 500ms. In tests, they are not debounced to
    // speed up test execution.
    _effectCleanup = effect(() async {
      final toSave = todos.map(_todoCodec.encode).toList(growable: false);
      await _todosRepository.saveTodos(toSave);
    });
  }

  void dispose() => _effectCleanup();
}

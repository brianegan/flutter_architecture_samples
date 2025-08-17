// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TodoStore on TodoStoreBase, Store {
  Computed<List<Todo>>? _$pendingTodosComputed;

  @override
  List<Todo> get pendingTodos =>
      (_$pendingTodosComputed ??= Computed<List<Todo>>(
        () => super.pendingTodos,
        name: 'TodoStoreBase.pendingTodos',
      )).value;
  Computed<List<Todo>>? _$completedTodosComputed;

  @override
  List<Todo> get completedTodos =>
      (_$completedTodosComputed ??= Computed<List<Todo>>(
        () => super.completedTodos,
        name: 'TodoStoreBase.completedTodos',
      )).value;
  Computed<bool>? _$hasCompletedTodosComputed;

  @override
  bool get hasCompletedTodos => (_$hasCompletedTodosComputed ??= Computed<bool>(
    () => super.hasCompletedTodos,
    name: 'TodoStoreBase.hasCompletedTodos',
  )).value;
  Computed<bool>? _$hasPendingTodosComputed;

  @override
  bool get hasPendingTodos => (_$hasPendingTodosComputed ??= Computed<bool>(
    () => super.hasPendingTodos,
    name: 'TodoStoreBase.hasPendingTodos',
  )).value;
  Computed<int>? _$numPendingComputed;

  @override
  int get numPending => (_$numPendingComputed ??= Computed<int>(
    () => super.numPending,
    name: 'TodoStoreBase.numPending',
  )).value;
  Computed<int>? _$numCompletedComputed;

  @override
  int get numCompleted => (_$numCompletedComputed ??= Computed<int>(
    () => super.numCompleted,
    name: 'TodoStoreBase.numCompleted',
  )).value;
  Computed<List<Todo>>? _$visibleTodosComputed;

  @override
  List<Todo> get visibleTodos =>
      (_$visibleTodosComputed ??= Computed<List<Todo>>(
        () => super.visibleTodos,
        name: 'TodoStoreBase.visibleTodos',
      )).value;

  late final _$filterAtom = Atom(
    name: 'TodoStoreBase.filter',
    context: context,
  );

  @override
  VisibilityFilter get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(VisibilityFilter value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$loaderAtom = Atom(
    name: 'TodoStoreBase.loader',
    context: context,
  );

  @override
  ObservableFuture<void> get loader {
    _$loaderAtom.reportRead();
    return super.loader;
  }

  bool _loaderIsInitialized = false;

  @override
  set loader(ObservableFuture<void> value) {
    _$loaderAtom.reportWrite(
      value,
      _loaderIsInitialized ? super.loader : null,
      () {
        super.loader = value;
        _loaderIsInitialized = true;
      },
    );
  }

  late final _$_loadTodosAsyncAction = AsyncAction(
    'TodoStoreBase._loadTodos',
    context: context,
  );

  @override
  Future<void> _loadTodos() {
    return _$_loadTodosAsyncAction.run(() => super._loadTodos());
  }

  late final _$TodoStoreBaseActionController = ActionController(
    name: 'TodoStoreBase',
    context: context,
  );

  @override
  void toggleAll() {
    final _$actionInfo = _$TodoStoreBaseActionController.startAction(
      name: 'TodoStoreBase.toggleAll',
    );
    try {
      return super.toggleAll();
    } finally {
      _$TodoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCompleted() {
    final _$actionInfo = _$TodoStoreBaseActionController.startAction(
      name: 'TodoStoreBase.clearCompleted',
    );
    try {
      return super.clearCompleted();
    } finally {
      _$TodoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filter: ${filter},
loader: ${loader},
pendingTodos: ${pendingTodos},
completedTodos: ${completedTodos},
hasCompletedTodos: ${hasCompletedTodos},
hasPendingTodos: ${hasPendingTodos},
numPending: ${numPending},
numCompleted: ${numCompleted},
visibleTodos: ${visibleTodos}
    ''';
  }
}

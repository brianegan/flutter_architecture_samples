// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_manager_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TodoManagerStore on _TodoManagerStore, Store {
  Computed<List<Todo>> _$pendingTodosComputed;

  @override
  List<Todo> get pendingTodos => (_$pendingTodosComputed ??=
          Computed<List<Todo>>(() => super.pendingTodos))
      .value;
  Computed<List<Todo>> _$completedTodosComputed;

  @override
  List<Todo> get completedTodos => (_$completedTodosComputed ??=
          Computed<List<Todo>>(() => super.completedTodos))
      .value;
  Computed<bool> _$hasCompletedTodosComputed;

  @override
  bool get hasCompletedTodos => (_$hasCompletedTodosComputed ??=
          Computed<bool>(() => super.hasCompletedTodos))
      .value;
  Computed<bool> _$hasPendingTodosComputed;

  @override
  bool get hasPendingTodos => (_$hasPendingTodosComputed ??=
          Computed<bool>(() => super.hasPendingTodos))
      .value;
  Computed<List<Todo>> _$visibleTodosComputed;

  @override
  List<Todo> get visibleTodos => (_$visibleTodosComputed ??=
          Computed<List<Todo>>(() => super.visibleTodos))
      .value;

  final _$activeTabAtom = Atom(name: '_TodoManagerStore.activeTab');

  @override
  TabType get activeTab {
    _$activeTabAtom.context.enforceReadPolicy(_$activeTabAtom);
    _$activeTabAtom.reportObserved();
    return super.activeTab;
  }

  @override
  set activeTab(TabType value) {
    _$activeTabAtom.context.conditionallyRunInAction(() {
      super.activeTab = value;
      _$activeTabAtom.reportChanged();
    }, _$activeTabAtom, name: '${_$activeTabAtom.name}_set');
  }

  final _$filterAtom = Atom(name: '_TodoManagerStore.filter');

  @override
  VisibilityFilter get filter {
    _$filterAtom.context.enforceReadPolicy(_$filterAtom);
    _$filterAtom.reportObserved();
    return super.filter;
  }

  @override
  set filter(VisibilityFilter value) {
    _$filterAtom.context.conditionallyRunInAction(() {
      super.filter = value;
      _$filterAtom.reportChanged();
    }, _$filterAtom, name: '${_$filterAtom.name}_set');
  }

  final _$loaderAtom = Atom(name: '_TodoManagerStore.loader');

  @override
  ObservableFuture<void> get loader {
    _$loaderAtom.context.enforceReadPolicy(_$loaderAtom);
    _$loaderAtom.reportObserved();
    return super.loader;
  }

  @override
  set loader(ObservableFuture<void> value) {
    _$loaderAtom.context.conditionallyRunInAction(() {
      super.loader = value;
      _$loaderAtom.reportChanged();
    }, _$loaderAtom, name: '${_$loaderAtom.name}_set');
  }

  final _$_loadTodosAsyncAction = AsyncAction('_loadTodos');

  @override
  Future<void> _loadTodos() {
    return _$_loadTodosAsyncAction.run(() => super._loadTodos());
  }

  final _$_TodoManagerStoreActionController =
      ActionController(name: '_TodoManagerStore');

  @override
  dynamic updateTab(TabType tab) {
    final _$actionInfo = _$_TodoManagerStoreActionController.startAction();
    try {
      return super.updateTab(tab);
    } finally {
      _$_TodoManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTodo(Todo todo) {
    final _$actionInfo = _$_TodoManagerStoreActionController.startAction();
    try {
      return super.addTodo(todo);
    } finally {
      _$_TodoManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTodo(Todo todo) {
    final _$actionInfo = _$_TodoManagerStoreActionController.startAction();
    try {
      return super.removeTodo(todo);
    } finally {
      _$_TodoManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeFilter(VisibilityFilter value) {
    final _$actionInfo = _$_TodoManagerStoreActionController.startAction();
    try {
      return super.changeFilter(value);
    } finally {
      _$_TodoManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllComplete() {
    final _$actionInfo = _$_TodoManagerStoreActionController.startAction();
    try {
      return super.markAllComplete();
    } finally {
      _$_TodoManagerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCompleted() {
    final _$actionInfo = _$_TodoManagerStoreActionController.startAction();
    try {
      return super.clearCompleted();
    } finally {
      _$_TodoManagerStoreActionController.endAction(_$actionInfo);
    }
  }
}

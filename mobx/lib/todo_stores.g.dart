// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_stores.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$Todo on _Todo, Store {
  final _$titleAtom = Atom(name: '_Todo.title');

  @override
  String get title {
    _$titleAtom.reportObserved();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.context.checkIfStateModificationsAreAllowed(_$titleAtom);
    super.title = value;
    _$titleAtom.reportChanged();
  }

  final _$notesAtom = Atom(name: '_Todo.notes');

  @override
  String get notes {
    _$notesAtom.reportObserved();
    return super.notes;
  }

  @override
  set notes(String value) {
    _$notesAtom.context.checkIfStateModificationsAreAllowed(_$notesAtom);
    super.notes = value;
    _$notesAtom.reportChanged();
  }

  final _$doneAtom = Atom(name: '_Todo.done');

  @override
  bool get done {
    _$doneAtom.reportObserved();
    return super.done;
  }

  @override
  set done(bool value) {
    _$doneAtom.context.checkIfStateModificationsAreAllowed(_$doneAtom);
    super.done = value;
    _$doneAtom.reportChanged();
  }

  final _$_TodoActionController = ActionController(name: '_Todo');

  @override
  void markDone(bool flag) {
    final _$actionInfo = _$_TodoActionController.startAction();
    try {
      return super.markDone(flag);
    } finally {
      _$_TodoActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTitle(String value) {
    final _$actionInfo = _$_TodoActionController.startAction();
    try {
      return super.setTitle(value);
    } finally {
      _$_TodoActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setNotes(String value) {
    final _$actionInfo = _$_TodoActionController.startAction();
    try {
      return super.setNotes(value);
    } finally {
      _$_TodoActionController.endAction(_$actionInfo);
    }
  }
}

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$TodoList on _TodoList, Store {
  final _$loaderAtom = Atom(name: '_TodoList.loader');

  @override
  ObservableFuture<void> get loader {
    _$loaderAtom.reportObserved();
    return super.loader;
  }

  @override
  set loader(ObservableFuture<void> value) {
    _$loaderAtom.context.checkIfStateModificationsAreAllowed(_$loaderAtom);
    super.loader = value;
    _$loaderAtom.reportChanged();
  }

  final _$_loadTodosAsyncAction = AsyncAction('_loadTodos');

  @override
  Future<void> _loadTodos() {
    return _$_loadTodosAsyncAction.run(() => super._loadTodos());
  }

  final _$_TodoListActionController = ActionController(name: '_TodoList');

  @override
  void addTodo(Todo todo) {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.addTodo(todo);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTodo(Todo todo) {
    final _$actionInfo = _$_TodoListActionController.startAction();
    try {
      return super.removeTodo(todo);
    } finally {
      _$_TodoListActionController.endAction(_$actionInfo);
    }
  }
}

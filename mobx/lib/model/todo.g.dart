// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Todo on _Todo, Store {
  Computed<bool> _$hasTitleComputed;

  @override
  bool get hasTitle =>
      (_$hasTitleComputed ??= Computed<bool>(() => super.hasTitle)).value;
  Computed<bool> _$hasNotesComputed;

  @override
  bool get hasNotes =>
      (_$hasNotesComputed ??= Computed<bool>(() => super.hasNotes)).value;

  final _$titleAtom = Atom(name: '_Todo.title');

  @override
  String get title {
    _$titleAtom.context.enforceReadPolicy(_$titleAtom);
    _$titleAtom.reportObserved();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.context.conditionallyRunInAction(() {
      super.title = value;
      _$titleAtom.reportChanged();
    }, _$titleAtom, name: '${_$titleAtom.name}_set');
  }

  final _$notesAtom = Atom(name: '_Todo.notes');

  @override
  String get notes {
    _$notesAtom.context.enforceReadPolicy(_$notesAtom);
    _$notesAtom.reportObserved();
    return super.notes;
  }

  @override
  set notes(String value) {
    _$notesAtom.context.conditionallyRunInAction(() {
      super.notes = value;
      _$notesAtom.reportChanged();
    }, _$notesAtom, name: '${_$notesAtom.name}_set');
  }

  final _$doneAtom = Atom(name: '_Todo.done');

  @override
  bool get done {
    _$doneAtom.context.enforceReadPolicy(_$doneAtom);
    _$doneAtom.reportObserved();
    return super.done;
  }

  @override
  set done(bool value) {
    _$doneAtom.context.conditionallyRunInAction(() {
      super.done = value;
      _$doneAtom.reportChanged();
    }, _$doneAtom, name: '${_$doneAtom.name}_set');
  }

  final _$_TodoActionController = ActionController(name: '_Todo');

  @override
  dynamic copyFrom(Todo todo) {
    final _$actionInfo = _$_TodoActionController.startAction();
    try {
      return super.copyFrom(todo);
    } finally {
      _$_TodoActionController.endAction(_$actionInfo);
    }
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Todo on _Todo, Store {
  final _$taskAtom = Atom(name: '_Todo.task');

  @override
  String get task {
    _$taskAtom.context.enforceReadPolicy(_$taskAtom);
    _$taskAtom.reportObserved();
    return super.task;
  }

  @override
  set task(String value) {
    _$taskAtom.context.conditionallyRunInAction(() {
      super.task = value;
      _$taskAtom.reportChanged();
    }, _$taskAtom, name: '${_$taskAtom.name}_set');
  }

  final _$noteAtom = Atom(name: '_Todo.note');

  @override
  String get note {
    _$noteAtom.context.enforceReadPolicy(_$noteAtom);
    _$noteAtom.reportObserved();
    return super.note;
  }

  @override
  set note(String value) {
    _$noteAtom.context.conditionallyRunInAction(() {
      super.note = value;
      _$noteAtom.reportChanged();
    }, _$noteAtom, name: '${_$noteAtom.name}_set');
  }

  final _$completeAtom = Atom(name: '_Todo.complete');

  @override
  bool get complete {
    _$completeAtom.context.enforceReadPolicy(_$completeAtom);
    _$completeAtom.reportObserved();
    return super.complete;
  }

  @override
  set complete(bool value) {
    _$completeAtom.context.conditionallyRunInAction(() {
      super.complete = value;
      _$completeAtom.reportChanged();
    }, _$completeAtom, name: '${_$completeAtom.name}_set');
  }
}

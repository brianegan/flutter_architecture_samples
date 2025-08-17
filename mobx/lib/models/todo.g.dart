// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Todo on TodoBase, Store {
  late final _$taskAtom = Atom(name: 'TodoBase.task', context: context);

  @override
  String get task {
    _$taskAtom.reportRead();
    return super.task;
  }

  @override
  set task(String value) {
    _$taskAtom.reportWrite(value, super.task, () {
      super.task = value;
    });
  }

  late final _$noteAtom = Atom(name: 'TodoBase.note', context: context);

  @override
  String get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(String value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  late final _$completeAtom = Atom(name: 'TodoBase.complete', context: context);

  @override
  bool get complete {
    _$completeAtom.reportRead();
    return super.complete;
  }

  @override
  set complete(bool value) {
    _$completeAtom.reportWrite(value, super.complete, () {
      super.complete = value;
    });
  }

  @override
  String toString() {
    return '''
task: ${task},
note: ${note},
complete: ${complete}
    ''';
  }
}

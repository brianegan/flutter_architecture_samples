// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

class _$TodoModel extends TodoModel {
  @override
  final String id;
  @override
  final bool complete;
  @override
  final String note;
  @override
  final String task;

  factory _$TodoModel([void Function(TodoModelBuilder b) updates]) =>
      (new TodoModelBuilder()..update(updates)).build();

  _$TodoModel._({this.id, this.complete, this.note, this.task}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('TodoModel', 'id');
    }
    if (complete == null) {
      throw new BuiltValueNullFieldError('TodoModel', 'complete');
    }
    if (note == null) {
      throw new BuiltValueNullFieldError('TodoModel', 'note');
    }
    if (task == null) {
      throw new BuiltValueNullFieldError('TodoModel', 'task');
    }
  }

  @override
  TodoModel rebuild(void Function(TodoModelBuilder b) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoModelBuilder toBuilder() => new TodoModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TodoModel &&
        id == other.id &&
        complete == other.complete &&
        note == other.note &&
        task == other.task;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), complete.hashCode), note.hashCode),
        task.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TodoModel')
          ..add('id', id)
          ..add('complete', complete)
          ..add('note', note)
          ..add('task', task))
        .toString();
  }
}

class TodoModelBuilder implements Builder<TodoModel, TodoModelBuilder> {
  _$TodoModel _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _complete;
  bool get complete => _$this._complete;
  set complete(bool complete) => _$this._complete = complete;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  String _task;
  String get task => _$this._task;
  set task(String task) => _$this._task = task;

  TodoModelBuilder();

  TodoModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _complete = _$v.complete;
      _note = _$v.note;
      _task = _$v.task;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TodoModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TodoModel;
  }

  @override
  void update(void Function(TodoModelBuilder b) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TodoModel build() {
    final _$result = _$v ??
        new _$TodoModel._(id: id, complete: complete, note: note, task: task);
    replace(_$result);
    return _$result;
  }
}

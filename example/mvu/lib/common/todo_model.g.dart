// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

class _$TodoModel extends TodoModel {
  @override
  final String id;
  @override
  final bool complete;
  @override
  final String note;
  @override
  final String task;

  factory _$TodoModel([void updates(TodoModelBuilder b)]) =>
      (new TodoModelBuilder()..update(updates)).build();

  _$TodoModel._({this.id, this.complete, this.note, this.task}) : super._() {
    if (id == null) throw new BuiltValueNullFieldError('TodoModel', 'id');
    if (complete == null)
      throw new BuiltValueNullFieldError('TodoModel', 'complete');
    if (note == null) throw new BuiltValueNullFieldError('TodoModel', 'note');
    if (task == null) throw new BuiltValueNullFieldError('TodoModel', 'task');
  }

  @override
  TodoModel rebuild(void updates(TodoModelBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoModelBuilder toBuilder() => new TodoModelBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! TodoModel) return false;
    return id == other.id &&
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
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$TodoModel;
  }

  @override
  void update(void updates(TodoModelBuilder b)) {
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

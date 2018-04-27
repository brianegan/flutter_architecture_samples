// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

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

class _$EditTodoModel extends EditTodoModel {
  @override
  final widgets.TextEditingController task;
  @override
  final widgets.TextEditingController note;
  @override
  final String id;

  factory _$EditTodoModel([void updates(EditTodoModelBuilder b)]) =>
      (new EditTodoModelBuilder()..update(updates)).build();

  _$EditTodoModel._({this.task, this.note, this.id}) : super._() {
    if (task == null)
      throw new BuiltValueNullFieldError('EditTodoModel', 'task');
    if (note == null)
      throw new BuiltValueNullFieldError('EditTodoModel', 'note');
    if (id == null) throw new BuiltValueNullFieldError('EditTodoModel', 'id');
  }

  @override
  EditTodoModel rebuild(void updates(EditTodoModelBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EditTodoModelBuilder toBuilder() => new EditTodoModelBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! EditTodoModel) return false;
    return task == other.task && note == other.note && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, task.hashCode), note.hashCode), id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('EditTodoModel')
          ..add('task', task)
          ..add('note', note)
          ..add('id', id))
        .toString();
  }
}

class EditTodoModelBuilder
    implements Builder<EditTodoModel, EditTodoModelBuilder> {
  _$EditTodoModel _$v;

  widgets.TextEditingController _task;
  widgets.TextEditingController get task => _$this._task;
  set task(widgets.TextEditingController task) => _$this._task = task;

  widgets.TextEditingController _note;
  widgets.TextEditingController get note => _$this._note;
  set note(widgets.TextEditingController note) => _$this._note = note;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  EditTodoModelBuilder();

  EditTodoModelBuilder get _$this {
    if (_$v != null) {
      _task = _$v.task;
      _note = _$v.note;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EditTodoModel other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$EditTodoModel;
  }

  @override
  void update(void updates(EditTodoModelBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$EditTodoModel build() {
    final _$result =
        _$v ?? new _$EditTodoModel._(task: task, note: note, id: id);
    replace(_$result);
    return _$result;
  }
}

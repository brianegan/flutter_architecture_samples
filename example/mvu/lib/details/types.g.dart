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

class _$DetailsModel extends DetailsModel {
  @override
  final TodoModel todo;

  factory _$DetailsModel([void updates(DetailsModelBuilder b)]) =>
      (new DetailsModelBuilder()..update(updates)).build();

  _$DetailsModel._({this.todo}) : super._() {
    if (todo == null)
      throw new BuiltValueNullFieldError('DetailsModel', 'todo');
  }

  @override
  DetailsModel rebuild(void updates(DetailsModelBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  DetailsModelBuilder toBuilder() => new DetailsModelBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! DetailsModel) return false;
    return todo == other.todo;
  }

  @override
  int get hashCode {
    return $jf($jc(0, todo.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DetailsModel')..add('todo', todo))
        .toString();
  }
}

class DetailsModelBuilder
    implements Builder<DetailsModel, DetailsModelBuilder> {
  _$DetailsModel _$v;

  TodoModelBuilder _todo;
  TodoModelBuilder get todo => _$this._todo ??= new TodoModelBuilder();
  set todo(TodoModelBuilder todo) => _$this._todo = todo;

  DetailsModelBuilder();

  DetailsModelBuilder get _$this {
    if (_$v != null) {
      _todo = _$v.todo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DetailsModel other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$DetailsModel;
  }

  @override
  void update(void updates(DetailsModelBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$DetailsModel build() {
    _$DetailsModel _$result;
    try {
      _$result = _$v ?? new _$DetailsModel._(todo: todo.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'todo';
        todo.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DetailsModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

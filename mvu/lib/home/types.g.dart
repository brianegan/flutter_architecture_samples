// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

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

class _$HomeModel extends HomeModel {
  @override
  final BodyModel body;

  factory _$HomeModel([void Function(HomeModelBuilder b) updates]) =>
      (new HomeModelBuilder()..update(updates)).build();

  _$HomeModel._({this.body}) : super._() {
    if (body == null) {
      throw new BuiltValueNullFieldError('HomeModel', 'body');
    }
  }

  @override
  HomeModel rebuild(void Function(HomeModelBuilder b) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeModelBuilder toBuilder() => new HomeModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeModel && body == other.body;
  }

  @override
  int get hashCode {
    return $jf($jc(0, body.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HomeModel')..add('body', body))
        .toString();
  }
}

class HomeModelBuilder implements Builder<HomeModel, HomeModelBuilder> {
  _$HomeModel _$v;

  BodyModel _body;
  BodyModel get body => _$this._body;
  set body(BodyModel body) => _$this._body = body;

  HomeModelBuilder();

  HomeModelBuilder get _$this {
    if (_$v != null) {
      _body = _$v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HomeModel;
  }

  @override
  void update(void Function(HomeModelBuilder b) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$HomeModel build() {
    final _$result = _$v ?? new _$HomeModel._(body: body);
    replace(_$result);
    return _$result;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of stats;

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

class _$StatsProps extends StatsProps {
  @override
  final int numCompleted;
  @override
  final int numActive;

  factory _$StatsProps([void updates(StatsPropsBuilder b)]) =>
      (new StatsPropsBuilder()..update(updates)).build();

  _$StatsProps._({this.numCompleted, this.numActive}) : super._() {
    if (numCompleted == null)
      throw new BuiltValueNullFieldError('StatsProps', 'numCompleted');
    if (numActive == null)
      throw new BuiltValueNullFieldError('StatsProps', 'numActive');
  }

  @override
  StatsProps rebuild(void updates(StatsPropsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsPropsBuilder toBuilder() => new StatsPropsBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! StatsProps) return false;
    return numCompleted == other.numCompleted && numActive == other.numActive;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, numCompleted.hashCode), numActive.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StatsProps')
          ..add('numCompleted', numCompleted)
          ..add('numActive', numActive))
        .toString();
  }
}

class StatsPropsBuilder implements Builder<StatsProps, StatsPropsBuilder> {
  _$StatsProps _$v;

  int _numCompleted;
  int get numCompleted => _$this._numCompleted;
  set numCompleted(int numCompleted) => _$this._numCompleted = numCompleted;

  int _numActive;
  int get numActive => _$this._numActive;
  set numActive(int numActive) => _$this._numActive = numActive;

  StatsPropsBuilder();

  StatsPropsBuilder get _$this {
    if (_$v != null) {
      _numCompleted = _$v.numCompleted;
      _numActive = _$v.numActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsProps other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$StatsProps;
  }

  @override
  void update(void updates(StatsPropsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$StatsProps build() {
    final _$result = _$v ??
        new _$StatsProps._(numCompleted: numCompleted, numActive: numActive);
    replace(_$result);
    return _$result;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of stats;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsProps extends StatsProps {
  @override
  final int numCompleted;
  @override
  final int numActive;

  factory _$StatsProps([void Function(StatsPropsBuilder) updates]) =>
      (new StatsPropsBuilder()..update(updates)).build();

  _$StatsProps._({this.numCompleted, this.numActive}) : super._() {
    if (numCompleted == null) {
      throw new BuiltValueNullFieldError('StatsProps', 'numCompleted');
    }
    if (numActive == null) {
      throw new BuiltValueNullFieldError('StatsProps', 'numActive');
    }
  }

  @override
  StatsProps rebuild(void Function(StatsPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsPropsBuilder toBuilder() => new StatsPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsProps &&
        numCompleted == other.numCompleted &&
        numActive == other.numActive;
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
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StatsProps;
  }

  @override
  void update(void Function(StatsPropsBuilder) updates) {
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

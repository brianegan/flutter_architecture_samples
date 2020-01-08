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

class _$StatsModel extends StatsModel {
  @override
  final BuiltList<TodoModel> items;
  @override
  final bool loading;
  @override
  final int activeCount;
  @override
  final int completedCount;

  factory _$StatsModel([void Function(StatsModelBuilder b) updates]) =>
      (new StatsModelBuilder()..update(updates)).build();

  _$StatsModel._(
      {this.items, this.loading, this.activeCount, this.completedCount})
      : super._() {
    if (items == null) {
      throw new BuiltValueNullFieldError('StatsModel', 'items');
    }
    if (loading == null) {
      throw new BuiltValueNullFieldError('StatsModel', 'loading');
    }
    if (activeCount == null) {
      throw new BuiltValueNullFieldError('StatsModel', 'activeCount');
    }
    if (completedCount == null) {
      throw new BuiltValueNullFieldError('StatsModel', 'completedCount');
    }
  }

  @override
  StatsModel rebuild(void Function(StatsModelBuilder b) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsModelBuilder toBuilder() => new StatsModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsModel &&
        items == other.items &&
        loading == other.loading &&
        activeCount == other.activeCount &&
        completedCount == other.completedCount;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, items.hashCode), loading.hashCode),
            activeCount.hashCode),
        completedCount.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StatsModel')
          ..add('items', items)
          ..add('loading', loading)
          ..add('activeCount', activeCount)
          ..add('completedCount', completedCount))
        .toString();
  }
}

class StatsModelBuilder implements Builder<StatsModel, StatsModelBuilder> {
  _$StatsModel _$v;

  ListBuilder<TodoModel> _items;
  ListBuilder<TodoModel> get items =>
      _$this._items ??= new ListBuilder<TodoModel>();
  set items(ListBuilder<TodoModel> items) => _$this._items = items;

  bool _loading;
  bool get loading => _$this._loading;
  set loading(bool loading) => _$this._loading = loading;

  int _activeCount;
  int get activeCount => _$this._activeCount;
  set activeCount(int activeCount) => _$this._activeCount = activeCount;

  int _completedCount;
  int get completedCount => _$this._completedCount;
  set completedCount(int completedCount) =>
      _$this._completedCount = completedCount;

  StatsModelBuilder();

  StatsModelBuilder get _$this {
    if (_$v != null) {
      _items = _$v.items?.toBuilder();
      _loading = _$v.loading;
      _activeCount = _$v.activeCount;
      _completedCount = _$v.completedCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StatsModel;
  }

  @override
  void update(void Function(StatsModelBuilder b) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StatsModel build() {
    _$StatsModel _$result;
    try {
      _$result = _$v ??
          new _$StatsModel._(
              items: items.build(),
              loading: loading,
              activeCount: activeCount,
              completedCount: completedCount);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'StatsModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

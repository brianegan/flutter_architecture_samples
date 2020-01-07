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

class _$TodosModel extends TodosModel {
  @override
  final bool isLoading;
  @override
  final BuiltList<TodoModel> items;
  @override
  final VisibilityFilter filter;
  @override
  final String loadingError;

  factory _$TodosModel([void Function(TodosModelBuilder b) updates]) =>
      (new TodosModelBuilder()..update(updates)).build();

  _$TodosModel._({this.isLoading, this.items, this.filter, this.loadingError})
      : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('TodosModel', 'isLoading');
    }
    if (items == null) {
      throw new BuiltValueNullFieldError('TodosModel', 'items');
    }
    if (filter == null) {
      throw new BuiltValueNullFieldError('TodosModel', 'filter');
    }
  }

  @override
  TodosModel rebuild(void Function(TodosModelBuilder b) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TodosModelBuilder toBuilder() => new TodosModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TodosModel &&
        isLoading == other.isLoading &&
        items == other.items &&
        filter == other.filter &&
        loadingError == other.loadingError;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, isLoading.hashCode), items.hashCode), filter.hashCode),
        loadingError.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TodosModel')
          ..add('isLoading', isLoading)
          ..add('items', items)
          ..add('filter', filter)
          ..add('loadingError', loadingError))
        .toString();
  }
}

class TodosModelBuilder implements Builder<TodosModel, TodosModelBuilder> {
  _$TodosModel _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  ListBuilder<TodoModel> _items;
  ListBuilder<TodoModel> get items =>
      _$this._items ??= new ListBuilder<TodoModel>();
  set items(ListBuilder<TodoModel> items) => _$this._items = items;

  VisibilityFilter _filter;
  VisibilityFilter get filter => _$this._filter;
  set filter(VisibilityFilter filter) => _$this._filter = filter;

  String _loadingError;
  String get loadingError => _$this._loadingError;
  set loadingError(String loadingError) => _$this._loadingError = loadingError;

  TodosModelBuilder();

  TodosModelBuilder get _$this {
    if (_$v != null) {
      _isLoading = _$v.isLoading;
      _items = _$v.items?.toBuilder();
      _filter = _$v.filter;
      _loadingError = _$v.loadingError;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TodosModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TodosModel;
  }

  @override
  void update(void Function(TodosModelBuilder b) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TodosModel build() {
    _$TodosModel _$result;
    try {
      _$result = _$v ??
          new _$TodosModel._(
              isLoading: isLoading,
              items: items.build(),
              filter: filter,
              loadingError: loadingError);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TodosModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

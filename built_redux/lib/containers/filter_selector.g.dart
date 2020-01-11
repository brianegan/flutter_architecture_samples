// GENERATED CODE - DO NOT MODIFY BY HAND

part of filter_selector;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FilterSelectorViewModel extends FilterSelectorViewModel {
  @override
  final OnFilterSelected onFilterSelected;
  @override
  final VisibilityFilter activeFilter;

  factory _$FilterSelectorViewModel(
          [void Function(FilterSelectorViewModelBuilder) updates]) =>
      (new FilterSelectorViewModelBuilder()..update(updates)).build();

  _$FilterSelectorViewModel._({this.onFilterSelected, this.activeFilter})
      : super._() {
    if (onFilterSelected == null) {
      throw new BuiltValueNullFieldError(
          'FilterSelectorViewModel', 'onFilterSelected');
    }
    if (activeFilter == null) {
      throw new BuiltValueNullFieldError(
          'FilterSelectorViewModel', 'activeFilter');
    }
  }

  @override
  FilterSelectorViewModel rebuild(
          void Function(FilterSelectorViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FilterSelectorViewModelBuilder toBuilder() =>
      new FilterSelectorViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    final _$dynamicOther = other as dynamic;
    return other is FilterSelectorViewModel &&
        onFilterSelected == _$dynamicOther.onFilterSelected &&
        activeFilter == other.activeFilter;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, onFilterSelected.hashCode), activeFilter.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FilterSelectorViewModel')
          ..add('onFilterSelected', onFilterSelected)
          ..add('activeFilter', activeFilter))
        .toString();
  }
}

class FilterSelectorViewModelBuilder
    implements
        Builder<FilterSelectorViewModel, FilterSelectorViewModelBuilder> {
  _$FilterSelectorViewModel _$v;

  OnFilterSelected _onFilterSelected;
  OnFilterSelected get onFilterSelected => _$this._onFilterSelected;
  set onFilterSelected(OnFilterSelected onFilterSelected) =>
      _$this._onFilterSelected = onFilterSelected;

  VisibilityFilter _activeFilter;
  VisibilityFilter get activeFilter => _$this._activeFilter;
  set activeFilter(VisibilityFilter activeFilter) =>
      _$this._activeFilter = activeFilter;

  FilterSelectorViewModelBuilder();

  FilterSelectorViewModelBuilder get _$this {
    if (_$v != null) {
      _onFilterSelected = _$v.onFilterSelected;
      _activeFilter = _$v.activeFilter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FilterSelectorViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FilterSelectorViewModel;
  }

  @override
  void update(void Function(FilterSelectorViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FilterSelectorViewModel build() {
    final _$result = _$v ??
        new _$FilterSelectorViewModel._(
            onFilterSelected: onFilterSelected, activeFilter: activeFilter);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

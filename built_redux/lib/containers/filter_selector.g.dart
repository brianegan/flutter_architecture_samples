// GENERATED CODE - DO NOT MODIFY BY HAND

part of filter_selector;

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

class _$FilterSelectorViewModel extends FilterSelectorViewModel {
  @override
  final OnFilterSelected onFilterSelected;
  @override
  final VisibilityFilter activeFilter;

  factory _$FilterSelectorViewModel(
          [void Function(FilterSelectorViewModelBuilder b) updates]) =>
      (FilterSelectorViewModelBuilder()..update(updates)).build();

  _$FilterSelectorViewModel._({this.onFilterSelected, this.activeFilter})
      : super._() {
    if (onFilterSelected == null) {
      throw BuiltValueNullFieldError(
          'FilterSelectorViewModel', 'onFilterSelected');
    }
    if (activeFilter == null) {
      throw BuiltValueNullFieldError('FilterSelectorViewModel', 'activeFilter');
    }
  }

  @override
  FilterSelectorViewModel rebuild(
          void Function(FilterSelectorViewModelBuilder b) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FilterSelectorViewModelBuilder toBuilder() =>
      FilterSelectorViewModelBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! FilterSelectorViewModel) return false;
    return onFilterSelected == other.onFilterSelected &&
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
    if (other == null) throw ArgumentError.notNull('other');
    _$v = other as _$FilterSelectorViewModel;
  }

  @override
  void update(void Function(FilterSelectorViewModelBuilder b) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FilterSelectorViewModel build() {
    final _$result = _$v ??
        _$FilterSelectorViewModel._(
            onFilterSelected: onFilterSelected, activeFilter: activeFilter);
    replace(_$result);
    return _$result;
  }
}

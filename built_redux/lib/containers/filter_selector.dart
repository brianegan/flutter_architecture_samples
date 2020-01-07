// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library filter_selector;

import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/containers/typedefs.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

part 'filter_selector.g.dart';

typedef OnFilterSelected = void Function(VisibilityFilter filter);

abstract class FilterSelectorViewModel
    implements Built<FilterSelectorViewModel, FilterSelectorViewModelBuilder> {
  FilterSelectorViewModel._();

  OnFilterSelected get onFilterSelected;

  VisibilityFilter get activeFilter;

  factory FilterSelectorViewModel(
          [void Function(FilterSelectorViewModelBuilder b) updates]) =
      _$FilterSelectorViewModel;

  factory FilterSelectorViewModel.from(
    AppActions actions,
    VisibilityFilter activeFilter,
  ) {
    return FilterSelectorViewModel((b) => b
      ..onFilterSelected = (filter) {
        actions.updateFilterAction(filter);
      }
      ..activeFilter = activeFilter);
  }
}

class FilterSelector
    extends StoreConnector<AppState, AppActions, VisibilityFilter> {
  final ViewModelBuilder<FilterSelectorViewModel> builder;

  @override
  VisibilityFilter connect(AppState state) => state.activeFilter;

  FilterSelector({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    VisibilityFilter activeFilter,
    AppActions actions,
  ) {
    return builder(
      context,
      FilterSelectorViewModel.from(
        actions,
        activeFilter,
      ),
    );
  }
}

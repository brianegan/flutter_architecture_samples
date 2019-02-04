// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/filter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FilterSelector extends StatelessWidget {
  final bool visible;

  FilterSelector({Key key, @required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return FilterButton(
          visible: visible,
          activeFilter: vm.activeFilter,
          onSelected: vm.onFilterSelected,
        );
      },
    );
  }
}

class _ViewModel {
  final Function(VisibilityFilter) onFilterSelected;
  final VisibilityFilter activeFilter;

  _ViewModel({
    @required this.onFilterSelected,
    @required this.activeFilter,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onFilterSelected: (filter) {
        store.dispatch(UpdateFilterAction(filter));
      },
      activeFilter: store.state.activeFilter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeFilter == other.activeFilter;

  @override
  int get hashCode => activeFilter.hashCode;
}

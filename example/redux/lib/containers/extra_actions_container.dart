// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/presentation/extra_actions_button.dart';

class ExtraActionsContainer extends StatelessWidget {
  ExtraActionsContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return new ExtraActionsButton(
          allComplete: vm.allComplete,
          onSelected: vm.onActionSelected,
        );
      },
    );
  }
}

class _ViewModel {
  final Function(ExtraAction) onActionSelected;
  final bool allComplete;

  _ViewModel({
    @required this.onActionSelected,
    @required this.allComplete,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      onActionSelected: (action) {
        if (action == ExtraAction.clearCompleted) {
          store.dispatch(new ClearCompletedAction());
        } else if (action == ExtraAction.toggleAllComplete) {
          store.dispatch(new ToggleAllAction());
        }
      },
      allComplete: allCompleteSelector(todosSelector(store.state)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          allComplete == other.allComplete;

  @override
  int get hashCode => allComplete.hashCode;
}

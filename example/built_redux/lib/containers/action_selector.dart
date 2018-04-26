// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/presentation/extra_actions_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class ExtraActionSelector extends StoreConnector<AppState, AppActions, bool> {
  ExtraActionSelector({Key key}) : super(key: key);

  @override
  bool connect(AppState state) => state.allCompleteSelector;

  @override
  Widget build(BuildContext context, bool allComplete, AppActions actions) {
    return ExtraActionsButton(
      allComplete: allComplete,
      onSelected: (action) {
        if (action == ExtraAction.clearCompleted) {
          actions.clearCompletedAction();
        } else if (action == ExtraAction.toggleAllComplete) {
          actions.toggleAllAction();
        }
      },
    );
  }
}

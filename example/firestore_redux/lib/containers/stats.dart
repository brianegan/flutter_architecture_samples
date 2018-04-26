// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/stats_counter.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Stats extends StatelessWidget {
  Stats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return StatsCounter(
          numActive: vm.numActive,
          numCompleted: vm.numCompleted,
        );
      },
    );
  }
}

class _ViewModel {
  final int numCompleted;
  final int numActive;

  _ViewModel({@required this.numCompleted, @required this.numActive});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      numActive: numActiveSelector(todosSelector(store.state)),
      numCompleted: numCompletedSelector(todosSelector(store.state)),
    );
  }
}

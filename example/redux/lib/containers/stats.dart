// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/presentation/stats_counter.dart';
import 'package:redux_sample/selectors/selectors.dart';

class Stats extends StatelessWidget {
  Stats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          numCompleted == other.numCompleted &&
          numActive == other.numActive;

  @override
  int get hashCode => numCompleted.hashCode ^ numActive.hashCode;

  @override
  String toString() {
    return '_ViewModel{numCompleted: $numCompleted, numActive: $numActive}';
  }
}

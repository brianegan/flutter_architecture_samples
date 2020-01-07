// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_base/src/mvi_core.dart';
import 'package:rxdart/rxdart.dart';

class StatsPresenter extends MviPresenter<StatsModel> {
  StatsPresenter(TodosInteractor interactor)
      : super(
          stream: Rx.combineLatest2(
            interactor.todos.map(_numActive),
            interactor.todos.map(_numComplete),
            (numActive, numComplete) => StatsModel(numActive, numComplete),
          ),
        );

  static int _numActive(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  }

  static int _numComplete(List<Todo> todos) {
    return todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
  }
}

class StatsModel {
  final int numActive;
  final int numComplete;

  StatsModel(this.numActive, this.numComplete);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatsModel &&
          runtimeType == other.runtimeType &&
          numActive == other.numActive &&
          numComplete == other.numComplete;

  @override
  int get hashCode => numActive.hashCode ^ numComplete.hashCode;

  @override
  String toString() {
    return 'StatsModel{numActive: $numActive, numComplete: $numComplete}';
  }
}

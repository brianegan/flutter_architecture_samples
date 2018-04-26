// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, TodosLoadedAction>(_setLoaded),
  TypedReducer<bool, TodosNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}

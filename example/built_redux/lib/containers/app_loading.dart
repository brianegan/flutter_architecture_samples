// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/containers/typedefs.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class AppLoading extends StoreConnector<AppState, AppActions, bool> {
  final ViewModelBuilder<bool> builder;

  AppLoading({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, bool state, AppActions actions) {
    return builder(context, state);
  }

  @override
  bool connect(AppState state) {
    return state.isLoading;
  }
}

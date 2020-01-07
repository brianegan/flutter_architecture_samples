// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/presentation/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class AddTodo extends StoreConnector<AppState, AppActions, Null> {
  AddTodo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, Null ignored, AppActions actions) {
    return AddEditScreen(
        isEditing: false,
        onSave: (String task, String note) {
          actions.addTodoAction(Todo.builder((b) {
            return b
              ..task = task
              ..note = note;
          }));
        });
  }

  @override
  Null connect(AppState state) {}
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:wire_flutter_todo/app.dart';
import 'package:wire_flutter_todo/const/TodoApplicationState.dart';
import 'package:wire_flutter_todo/controller/TodoController.dart';
import 'file:///Users/vladimir.minkin/Documents/Projects/Personal/Flutter/flutter_architecture_samples/wire/web/src/WebDatabaseService.dart';

import '../../lib/const/TodoDataParams.dart';
import '../../lib/model/TodoModel.dart';

var todoModel;
var todoController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Wire.data(TodoDataParams.STATE, TodoApplicationState.LOADING);

  var databaseService = WebDatabaseService();
  await databaseService.init(TodoModel.LOCAL_STORAGE_KEY);

  todoModel = TodoModel(databaseService);
  todoController = TodoController(todoModel);

  runApp(WireApp());

  Wire.data(TodoDataParams.STATE, TodoApplicationState.READY);
}

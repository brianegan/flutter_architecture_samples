// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire/wire.dart';

import 'app.dart';
import 'const/TodoDataParams.dart';
import 'const/TodoApplicationState.dart';
import 'controller/TodoController.dart';
import 'model/TodoModel.dart';
import 'service/MobileDatabaseService.dart';

var todoModel;
var todoController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Wire.data(TodoDataParams.STATE, TodoApplicationState.LOADING);

  var databaseService = MobileDatabaseService();
  await databaseService.init(TodoModel.LOCAL_STORAGE_KEY);

  todoModel = TodoModel(databaseService);
  todoController = TodoController(todoModel);

  runApp(WireApp());

  Wire.data(TodoDataParams.STATE, TodoApplicationState.READY);
}

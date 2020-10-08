// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:rvms_model_sample/display_todos/_model/todo.dart';

abstract class RepositoryService {

  /// Loads todos first from File storage. If they don't exist or encounter an
  /// error, it attempts to load the Todos from a Web Service.
  Future<List<Todo>> loadTodos();

  // Persists todos to local disk and the web
  Future saveTodos(List<Todo> todos);
}

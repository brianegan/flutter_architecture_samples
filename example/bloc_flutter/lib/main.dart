// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_flutter_sample/app.dart';
import 'package:bloc_flutter_sample/dependency_injection.dart';
import 'package:bloc_flutter_sample/todos_bloc_provider.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new TodosBlocProvider(
    child: new BlocApp(),
    bloc: new TodosListBloc(
      injector.repository
    ),
  ));
}

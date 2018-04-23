// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:meta/meta.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/localization.dart';
import 'package:mvi_flutter_sample/screens/add_edit_screen.dart';
import 'package:mvi_flutter_sample/screens/home_screen.dart';

void main({
  @required TodosInteractor todosRepository,
  @required UserInteractor userInteractor,
}) {
  // ignore: deprecated_member_use
  MaterialPageRoute.debugEnableFadingRoutes = true;

  runApp(new Injector(
    todosInteractor: todosRepository,
    userInteractor: userInteractor,
    child: new MaterialApp(
      title: new BlocLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        new ArchSampleLocalizationsDelegate(),
        new InheritedWidgetLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) {
          return new HomeScreen(
            todosInteractor: Injector.of(context).todosInteractor,
            userInteractor: Injector.of(context).userInteractor,
          );
        },
        ArchSampleRoutes.addTodo: (context) {
          return new AddEditScreen(
            addTodo: Injector.of(context).todosInteractor.addNewTodo,
          );
        },
      },
    ),
  ));
}

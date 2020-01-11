// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/localization.dart';
import 'package:mvi_flutter_sample/screens/add_edit_screen.dart';
import 'package:mvi_flutter_sample/screens/home_screen.dart';
import 'package:todos_app_core/todos_app_core.dart';

class MviApp extends StatelessWidget {
  final TodosInteractor todosRepository;
  final UserInteractor userInteractor;

  const MviApp({Key key, this.todosRepository, this.userInteractor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
      todosInteractor: todosRepository,
      userInteractor: userInteractor,
      child: MaterialApp(
        onGenerateTitle: (context) => BlocLocalizations.of(context).appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          InheritedWidgetLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return HomeScreen();
          },
          ArchSampleRoutes.addTodo: (context) {
            return AddEditScreen(
              addTodo: Injector.of(context).todosInteractor.addNewTodo,
            );
          },
        },
      ),
    );
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_flutter_sample/dependency_injection.dart';
import 'package:bloc_flutter_sample/localization.dart';
import 'package:bloc_flutter_sample/screens/add_edit_screen.dart';
import 'package:bloc_flutter_sample/screens/home_screen.dart';
import 'package:bloc_flutter_sample/widgets/todos_bloc_provider.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

void runBlocApp({
  @required TodosInteractor todosInteractor,
  @required UserRepository userRepository,
}) {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Injector(
    todosInteractor: todosInteractor,
    userRepository: userRepository,
    child: TodosBlocProvider(
      bloc: TodosListBloc(todosInteractor),
      child: MaterialApp(
        title: BlocLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          InheritedWidgetLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return HomeScreen(
              repository: Injector.of(context).userRepository,
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return AddEditScreen(
              addTodo: TodosBlocProvider.of(context).addTodo.add,
            );
          },
        },
      ),
    ),
  ));
}

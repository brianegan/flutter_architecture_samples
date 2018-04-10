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
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository/todos_repository.dart';

void main({
  @required ReactiveTodosRepository todosRepository,
  @required UserRepository userRepository,
}) {
  // ignore: deprecated_member_use
  MaterialPageRoute.debugEnableFadingRoutes = true;

  runApp(new Injector(
    todosRepository: todosRepository,
    userRepository: userRepository,
    child: new TodosBlocProvider(
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
              repository: Injector.of(context).userRepository,
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return new AddEditScreen(
              addTodo: TodosBlocProvider.of(context).addTodo.add,
            );
          },
        },
      ),
      bloc: new TodosListBloc(todosRepository),
    ),
  ));
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter_sample/dependency_injection.dart';
import 'package:simple_bloc_flutter_sample/localization.dart';
import 'package:simple_bloc_flutter_sample/screens/add_edit_screen.dart';
import 'package:simple_bloc_flutter_sample/screens/home_screen.dart';
import 'package:simple_bloc_flutter_sample/widgets/todos_bloc_provider.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class SimpleBlocApp extends StatelessWidget {
  final TodosInteractor todosInteractor;
  final UserRepository userRepository;

  const SimpleBlocApp({
    Key key,
    this.todosInteractor,
    this.userRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
      todosInteractor: todosInteractor,
      userRepository: userRepository,
      child: TodosBlocProvider(
        bloc: TodosListBloc(todosInteractor),
        child: MaterialApp(
          onGenerateTitle: (context) => BlocLocalizations.of(context).appTitle,
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
                addTodo: TodosBlocProvider.of(context).addTodo,
              );
            },
          },
        ),
      ),
    );
  }
}

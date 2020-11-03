// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/localization.dart';
import 'package:binder_sample/refs.dart';
import 'package:binder_sample/screens/add_edit_screen.dart';
import 'package:binder_sample/screens/home_screen.dart';
import 'package:binder_sample/widgets/todos_logic_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class BinderApp extends StatelessWidget {
  const BinderApp({Key key, @required this.repository}) : super(key: key);

  final TodosRepository repository;

  @override
  Widget build(BuildContext context) {
    return BinderScope(
      overrides: [todosRepositoryRef.overrideWith((scope) => repository)],
      child: TodosLogicLoader(
        child: MaterialApp(
          onGenerateTitle: (context) =>
              BinderLocalizations.of(context).appTitle,
          theme: ArchSampleTheme.theme,
          localizationsDelegates: [
            ArchSampleLocalizationsDelegate(),
            BinderLocalizationsDelegate(),
          ],
          routes: {
            ArchSampleRoutes.home: (_) => const HomeScreen(),
            ArchSampleRoutes.addTodo: (_) => const AddEditScreen(),
          },
        ),
      ),
    );
  }
}

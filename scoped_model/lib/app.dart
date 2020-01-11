// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/localization.dart';
import 'package:scoped_model_sample/screens/add_edit_screen.dart';
import 'package:scoped_model_sample/screens/home_screen.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class ScopedModelApp extends StatelessWidget {
  final TodosRepository repository;

  ScopedModelApp({
    @required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      onGenerateTitle: (context) =>
          ScopedModelLocalizations.of(context).appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        ScopedModelLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => HomeScreen(),
        ArchSampleRoutes.addTodo: (context) => AddEditScreen(),
      },
    );

    return ScopedModel<TodoListModel>(
      model: TodoListModel(
        repository: repository,
      ),
      child: app,
    );
  }
}

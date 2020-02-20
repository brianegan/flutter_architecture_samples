// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:change_notifier_provider_sample/add_todo_screen.dart';
import 'package:change_notifier_provider_sample/localization.dart';
import 'package:change_notifier_provider_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'home/home_screen.dart';

class ProviderApp extends StatelessWidget {
  final TodosRepository repository;

  ProviderApp({
    @required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoListModel(repository: repository)..loadTodos(),
      child: MaterialApp(
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          ProviderLocalizationsDelegate(),
        ],
        onGenerateTitle: (context) =>
            ProviderLocalizations.of(context).appTitle,
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddTodoScreen(),
        },
      ),
    );
  }
}

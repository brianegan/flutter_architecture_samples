// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/localization.dart';
import 'package:provider_sample/screens/add_edit_screen.dart';
import 'package:provider_sample/screens/home_screen.dart';
import 'package:provider_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class ProviderApp extends StatelessWidget {
  final TodosRepository repository;

  ProviderApp({
    @required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      title: ProviderLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        ProviderLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => HomeScreen(),
        ArchSampleRoutes.addTodo: (context) => AddEditScreen(),
      },
    );

    return ChangeNotifierProvider(
      builder: (context) => TodoListModel(
            repository: repository,
          ),
      child: app,
    );
  }
}

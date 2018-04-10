import 'package:bloc_flutter_sample/localization.dart';
import 'package:bloc_flutter_sample/screens/add_edit_screen.dart';
import 'package:bloc_flutter_sample/screens/home_screen.dart';
import 'package:bloc_flutter_sample/todos_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

class BlocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: new BlocLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        new ArchSampleLocalizationsDelegate(),
        new InheritedWidgetLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => new HomeScreen(),
        ArchSampleRoutes.addTodo: (context) {
          return new AddEditScreen(
            addTodo: TodosBlocProvider.of(context).addTodo.add,
          );
        },
      },
    );
  }
}

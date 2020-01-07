// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';
import 'package:scoped_model_sample/localization.dart';

import 'package:mvc/src/screens/add_edit_screen.dart';
import 'package:mvc/src/screens/home_screen.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mvc/src/Controller.dart';

class MVCApp extends AppMVC {
  MVCApp({Key key}) : super(con: _controller, key: key);

  /// An external reference to the Controller if you wish. -gp
  static final Con _controller = Con();

  static MaterialApp _app;

  static String get title => _app.title.toString();

  @override
  Widget build(BuildContext context) {
    _app = MaterialApp(
      title: 'mvc example',
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
    return _app;
  }
}

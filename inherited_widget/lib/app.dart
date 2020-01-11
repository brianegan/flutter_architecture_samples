// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:inherited_widget_sample/localization.dart';
import 'package:inherited_widget_sample/screens/add_edit_screen.dart';
import 'package:inherited_widget_sample/screens/home_screen.dart';
import 'package:todos_app_core/todos_app_core.dart';

class InheritedWidgetApp extends StatelessWidget {
  const InheritedWidgetApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          InheritedWidgetLocalizations.of(context).appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        InheritedWidgetLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => HomeScreen(),
        ArchSampleRoutes.addTodo: (context) => AddEditScreen(),
      },
    );
  }
}

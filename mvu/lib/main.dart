import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:mvu/common/router.dart' as router;
import 'package:mvu/home/home.dart' as home;
import 'package:mvu/home/types.dart';
import 'package:mvu/edit/edit.dart' as edit;
import 'localization.dart';
import 'package:mvu/common/repository_commands.dart' show repoCmds;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        MvuLocalizationsDelegate()
      ],
      home: Builder(
        builder: (c) {
          router.init(c);
          return home.createProgram(AppTab.todos).build();
        },
      ),
      routes: {
        ArchSampleRoutes.addTodo: (_) => edit.createProgram(repoCmds).build()
      },
    );
  }
}

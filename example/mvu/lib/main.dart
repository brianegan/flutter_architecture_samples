import 'package:flutter/material.dart';

import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

import 'package:mvu/common/router.dart' as router;
import 'package:mvu/home/home.dart' as home;
import 'package:mvu/home/types.dart';
import 'package:mvu/edit/edit.dart' as edit;
import 'Localization.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        new ArchSampleLocalizationsDelegate(),
        new MvuLocalizationsDelegate()
      ],
      home: new Builder(
        builder: (c) {
          router.init(c);
          return home.createProgram().buildWith(initArg: AppTab.todos);
        },
      ),
      routes: {
        ArchSampleRoutes.addTodo: (_) => edit.createProgram().buildWith()
      },
    );
  }
}

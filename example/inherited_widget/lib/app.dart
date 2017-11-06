import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:inherited_widget_sample/localization.dart';
import 'package:inherited_widget_sample/screens/add_edit_screen.dart';
import 'package:inherited_widget_sample/screens/home_screen.dart';

class InheritedWidgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: new InheritedWidgetLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        new ArchSampleLocalizationsDelegate(),
        new InheritedWidgetLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) => new HomeScreen(),
        ArchSampleRoutes.addTodo: (context) => new AddEditScreen(),
      },
    );
  }
}

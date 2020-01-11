import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:frideos_library/app_state.dart';
import 'package:frideos_library/localization.dart';
import 'package:frideos_library/screens/add_edit_screen.dart';
import 'package:frideos_library/screens/homescreen.dart';
import 'package:todos_app_core/todos_app_core.dart';

void main() {
  runApp(FrideosApp());
}

class FrideosApp extends StatelessWidget {
  final appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateProvider<AppState>(
      appState: appState,
      child: MaterialApp(
        onGenerateTitle: (context) => FrideosLocalizations.of(context).appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          FrideosLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddEditScreen(),
        },
      ),
    );
  }
}

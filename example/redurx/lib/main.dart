library redurx_sample;

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/actions/fetch_todos.dart';
import 'package:redurx_sample/data/todos_repository.dart';
import 'package:redurx_sample/localizations.dart';
import 'package:redurx_sample/middlewares/todos_middleware.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/screens/add_edit_screen.dart';
import 'package:redurx_sample/screens/home_screen.dart';

void main() {
  final initialState = AppState.loading();
  final store = Store<AppState>(initialState);

  store.add(TodosMiddleware(TodosRepository()));
  store.dispatch(FetchTodos());

  runApp(Provider(store: store, child: ReduRxApp()));
}

class ReduRxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ReduRxLocalizations().appTitle,
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [
        ArchSampleLocalizationsDelegate(),
        ReduRxLocalizationsDelegate(),
      ],
      routes: {
        ArchSampleRoutes.home: (context) {
          return HomeScreen();
        },
        ArchSampleRoutes.addTodo: (context) {
          return AddEditScreen(isEditing: false);
        },
      },
    );
  }
}

library built_redux_sample;

import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/containers/add_todo.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/localization.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/reducers/reducers.dart';
import 'package:built_redux_sample/middleware/store_todos_middleware.dart';
import 'package:built_redux_sample/presentation/home_screen.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

void main() {
  runApp(new BuiltReduxApp());
}

class BuiltReduxApp extends StatelessWidget {
  final store = new Store<AppState, AppStateBuilder, AppActions>(
    reducerBuilder.build(),
    new AppState.loading(),
    new AppActions(),
    middleware: [
      createStoreTodosMiddleware(),
    ],
  );

  BuiltReduxApp() {}

  @override
  Widget build(BuildContext context) {
    return new ReduxProvider(
      store: store,
      child: new MaterialApp(
        title: new BuiltReduxLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          new ArchSampleLocalizationsDelegate(),
          new BuiltReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            store.actions.fetchTodosAction();

            return new HomeScreen();
          },
          ArchSampleRoutes.addTodo: (context) {
            return new AddTodo();
          },
        },
      ),
    );
  }
}

library built_redux_sample;

import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/containers/add_todo.dart';
import 'package:built_redux_sample/data/todos_service.dart';
import 'package:built_redux_sample/data_model/models.dart';
import 'package:built_redux_sample/localization.dart';
import 'package:built_redux_sample/redux/actions.dart';
import 'package:built_redux_sample/redux/reducers.dart';
import 'package:built_redux_sample/storeTodosMiddleware.dart';
import 'package:built_redux_sample/widgets/home_screen.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

void main() {
  runApp(new BuiltReduxApp());
}

class BuiltReduxApp extends StatelessWidget {
  final TodosService service;
  final Store<AppState, AppStateBuilder, AppActions> store;

  factory BuiltReduxApp() {
    final service = const TodosService();
    final store = new Store<AppState, AppStateBuilder, AppActions>(
      reducerBuilder.build(),
      new AppState.loading(),
      new AppActions(),
      middleware: [
        createStoreTodosMiddleware(service),
      ],
    );

    return new BuiltReduxApp._(store, service);
  }

  BuiltReduxApp._(this.store, this.service);

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

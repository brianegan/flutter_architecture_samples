// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/containers/add_todo.dart';
import 'package:fire_redux_sample/localization.dart';
import 'package:fire_redux_sample/middleware/store_todos_middleware.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/presentation/home_screen.dart';
import 'package:fire_redux_sample/reducers/app_state_reducer.dart';
import 'package:fire_redux_sample/todos_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main([TodosService service]) {
  runApp(new ReduxApp(
    service: service,
  ));
}

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;

  ReduxApp({
    Key key,
    TodosService service,
  })  : store = new Store<AppState>(
          appReducer,
          initialState: new AppState.loading(),
          middleware: createStoreTodosMiddleware(
            service ??
                new FirestoreService(
                  FirebaseAuth.instance,
                  Firestore.instance,
                ),
          ),
        ),
        super(key: key) {
    store.dispatch(new InitAppAction());
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: new FirestoreReduxLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          new ArchSampleLocalizationsDelegate(),
          new FirestoreReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) {
            return new StoreBuilder<AppState>(
              builder: (context, store) {
                return new HomeScreen();
              },
            );
          },
          ArchSampleRoutes.addTodo: (context) {
            return new AddTodo();
          },
        },
      ),
    );
  }
}

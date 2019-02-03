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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_repository/reactive_todos_repository.dart';
import 'package:firebase_flutter_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todos_repository/todos_repository.dart';

void main([
  ReactiveTodosRepository todosRepository,
  UserRepository userRepository,
]) {
  runApp(ReduxApp(
    todosRepository: todosRepository,
    userRepository: userRepository,
  ));
}

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;

  ReduxApp({
    Key key,
    ReactiveTodosRepository todosRepository,
    UserRepository userRepository,
  })  : store = Store<AppState>(
          appReducer,
          initialState: AppState.loading(),
          middleware: createStoreTodosMiddleware(
            todosRepository ??
                FirestoreReactiveTodosRepository(Firestore.instance),
            userRepository ?? FirebaseUserRepository(FirebaseAuth.instance),
          ),
        ),
        super(key: key) {
    store.dispatch(InitAppAction());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: FirestoreReduxLocalizations().appTitle,
        theme: ArchSampleTheme.theme,
        localizationsDelegates: [
          ArchSampleLocalizationsDelegate(),
          FirestoreReduxLocalizationsDelegate(),
        ],
        routes: {
          ArchSampleRoutes.home: (context) => HomeScreen(),
          ArchSampleRoutes.addTodo: (context) => AddTodo(),
        },
      ),
    );
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/firestore_services.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';
import 'package:todos_repository/src/web_client.dart';

class MockFirestoreServices implements FirestoreServices {
  void anonymousLogin(store, [delayAuth = const Duration(milliseconds: 1000)]) {
    new Future.delayed(delayAuth, () {
      todosListener(store);
    });
  }

  void todosListener(store, {webClient = const WebClient()}) {
    var todosList = [];
    webClient.fetchTodos().then((listTodoEntity) {
      todosList = listTodoEntity.map(Todo.fromEntity).toList();
      store.dispatch(new LoadTodosAction(todosList));
    });
  }

  void addNewTodo(store, newTodo) {
    List<Todo> todos = todosSelector(store.state);
    List<Todo> newTodos = [];
    for (Todo todo in todos) {
      newTodos.add(todo.copyWith());
    }
    newTodos.add(newTodo);
    store.dispatch(new LoadTodosAction(newTodos));
  }

  void deleteTodo(store, List<String> idList) {
    List<Todo> todos = todosSelector(store.state);
    List<Todo> newTodos = [];
    for (Todo todo in todos) {
      newTodos.add(todo.copyWith());
    }
    for (var id in idList) {
      Todo todo = todoSelector(newTodos, id).value;
      newTodos.remove(todo);
    }
    store.dispatch(new LoadTodosAction(newTodos));
  }

  void updateTodo(store, todo) {
    List<Todo> todos = todosSelector(store.state);
    List<Todo> newTodos = [];
    for (Todo todo in todos) {
      newTodos.add(todo.copyWith());
    }
    int todoIndex = 0;
    for (var searchTodo in newTodos) {
      if (searchTodo.id == todo.id) {
        break;
      }
      todoIndex++;
    }
    newTodos.replaceRange(todoIndex, todoIndex + 1, [todo]);
    store.dispatch(new LoadTodosAction(newTodos));
  }
}

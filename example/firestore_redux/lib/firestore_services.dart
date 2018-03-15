// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/selectors/selectors.dart';

class FirestoreServices {
  void anonymousLogin(store) {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
        var isAnonymous = user.isAnonymous;
        var uid = user.uid;
        print(
            'In FirestoreServices, isAnonymous = $isAnonymous and uid = $uid');
        todosListener(store);
      }
      else {
        FirebaseAuth.instance.signInAnonymously().then((user) {
          todosListener(store);
        });
      }
    });
  }

  void todosListener(store) {
    Firestore.instance.collection('todos').snapshots.listen((snapshot) {
      var todosList = [];
      snapshot.documents.forEach((doc) {
        todosList.add(_convertSnapshotToTodo(doc));
      });
      store.dispatch(new LoadTodosAction(todosList));
    });
  }

  Todo _convertSnapshotToTodo(DocumentSnapshot document) {
    return new Todo(
      document['task'],
      complete: document['complete'] ?? false,
      id: document.documentID,
      note: document['note'] ?? '',
    );
  }

  void addNewTodo(store, todo) {
    Firestore.instance.collection('todos').document(todo.id).setData(
        {'complete': todo.complete, 'task': todo.task, 'note': todo.note});
  }

  void deleteTodo(store, List<String> idList) {
    // Code below updates the store synchronously prior to calling delete on
    //  Firestore. Without this an error will be thrown when using the
    //  dismissable widget action to delete a todo.
    //  Feels a little hacky, but it seems to work.
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

    Firestore.instance.collection('todos').document(idList[0]).delete();
  }

  void updateTodo(store, todo) {
    Firestore.instance.collection('todos').document(todo.id).updateData(
        {'complete': todo.complete, 'task': todo.task, 'note': todo.note});
  }
}

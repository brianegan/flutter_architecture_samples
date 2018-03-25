// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_repository/reactive_todos_repository.dart';
import 'package:firebase_flutter_repository/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_repository/todos_repository.dart';

main() {
  group('FirebaseUserRepository', () {
    test('should log the user in anonymously', () async {
      final auth = new MockFirebaseAuth();
      final repository = new FirebaseUserRepository(auth);

      when(auth.signInAnonymously()).thenReturn(new MockFirebaseUser());

      final entity = await repository.login();

      expect(entity, new isInstanceOf<UserEntity>());
    });
  });

  group('FirebaseReactiveTodosRepository', () {
    test('should send new todos to firestore', () {
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final document = new MockDocumentReference();
      final repository = new FirebaseReactiveTodosRepository(firestore);
      final todo = new TodoEntity('A', '1', '', true);

      when(firestore.collection(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.document(todo.id)).thenReturn(document);

      repository.addNewTodo(todo);

      verify(document.setData(todo.toJson()));
    });

    test('should update todos on firestore', () {
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final document = new MockDocumentReference();
      final repository = new FirebaseReactiveTodosRepository(firestore);
      final todo = new TodoEntity('A', '1', '', true);

      when(firestore.collection(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.document(todo.id)).thenReturn(document);

      repository.updateTodo(todo);

      verify(document.updateData(todo.toJson()));
    });

    test('should listen for updates to the collection', () {
      final todo = new TodoEntity('A', '1', '', true);
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final snapshot = new MockQuerySnapshot();
      final snapshots = new Stream.fromIterable([snapshot]);
      final document = new MockDocumentSnapshot(todo.toJson());
      final repository = new FirebaseReactiveTodosRepository(firestore);

      when(firestore.collection(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.snapshots).thenReturn(snapshots);
      when(snapshot.documents).thenReturn([document]);
      when(document.documentID).thenReturn(todo.id);

      expect(repository.todos(), emits([todo]));
    });

    test('should delete todos on firestore', () {
      final todoA = 'A';
      final todoB = 'B';
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final documentA = new MockDocumentReference();
      final documentB = new MockDocumentReference();
      final repository = new FirebaseReactiveTodosRepository(firestore);

      when(firestore.collection(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.document(todoA)).thenReturn(documentA);
      when(collection.document(todoB)).thenReturn(documentB);
      when(documentA.delete()).thenReturn(new Future.value());
      when(documentB.delete()).thenReturn(new Future.value());

      repository.deleteTodo([todoA, todoB]);

      verify(documentA.delete());
      verify(documentB.delete());
    });
  });
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> data;

  MockDocumentSnapshot([this.data]);

  dynamic operator [](String key) => data[key];
}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

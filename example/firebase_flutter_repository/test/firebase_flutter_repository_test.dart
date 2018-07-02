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
      final auth = MockFirebaseAuth();
      final repository = FirebaseUserRepository(auth);

      when(auth.signInAnonymously())
          .thenReturn(new Future.value(MockFirebaseUser()));

      final entity = await repository.login();

      expect(entity, isInstanceOf<UserEntity>());
    });
  });

  group('FirebaseReactiveTodosRepository', () {
    test('should send todos to firestore', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final repository = FirestoreReactiveTodosRepository(firestore);
      final todo = TodoEntity('A', '1', '', true);

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.document(todo.id)).thenReturn(document);

      repository.addNewTodo(todo);

      verify(document.setData(todo.toJson()));
    });

    test('should update todos on firestore', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final repository = FirestoreReactiveTodosRepository(firestore);
      final todo = TodoEntity('A', '1', '', true);

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.document(todo.id)).thenReturn(document);

      repository.updateTodo(todo);

      verify(document.updateData(todo.toJson()));
    });

    test('should listen for updates to the collection', () {
      final todo = TodoEntity('A', '1', '', true);
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final snapshot = MockQuerySnapshot();
      final snapshots = Stream.fromIterable([snapshot]);
      final document = MockDocumentSnapshot(todo.toJson());
      final repository = FirestoreReactiveTodosRepository(firestore);

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.snapshots()).thenReturn(snapshots);
      when(snapshot.documents).thenReturn([document]);
      when(document.documentID).thenReturn(todo.id);

      expect(repository.todos(), emits([todo]));
    });

    test('should delete todos on firestore', () async {
      final todoA = 'A';
      final todoB = 'B';
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final documentA = MockDocumentReference();
      final documentB = MockDocumentReference();
      final repository = FirestoreReactiveTodosRepository(firestore);

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.document(todoA)).thenReturn(documentA);
      when(collection.document(todoB)).thenReturn(documentB);
      when(documentA.delete()).thenReturn(Future.value());
      when(documentB.delete()).thenReturn(Future.value());

      await repository.deleteTodo([todoA, todoB]);

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

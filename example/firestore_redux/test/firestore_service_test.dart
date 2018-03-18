// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_redux_sample/firestore_service.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

main() {
  group('FirestoreService', () {
    test('should log the user in anonymously', () {
      final auth = new MockFirebaseAuth();
      final firestore = new MockFirestore();
      final service = new FirestoreService(auth, firestore);

      service.anonymousLogin();

      verify(auth.signInAnonymously());
    });

    test('should send new todos to firestore', () {
      final auth = new MockFirebaseAuth();
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final document = new MockDocumentReference();
      final service = new FirestoreService(auth, firestore);
      final todo = new Todo('A');

      when(firestore.collection(FirestoreService.path)).thenReturn(collection);
      when(collection.document(todo.id)).thenReturn(document);

      service.addNewTodo(todo);

      verify(document.setData(any));
    });

    test('should update todos on firestore', () {
      final auth = new MockFirebaseAuth();
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final document = new MockDocumentReference();
      final service = new FirestoreService(auth, firestore);
      final todo = new Todo('A');

      when(firestore.collection(FirestoreService.path)).thenReturn(collection);
      when(collection.document(todo.id)).thenReturn(document);

      service.updateTodo(todo);

      verify(document.updateData(todo.toMap()));
    });

    test('should listen for updates to the collection', () {
      final todo = new Todo('A');
      final auth = new MockFirebaseAuth();
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final snapshot = new MockQuerySnapshot();
      final snapshots = new Stream.fromIterable([snapshot]);
      final document = new MockDocumentSnapshot(todo.toMap());
      final service = new FirestoreService(auth, firestore);

      when(firestore.collection(FirestoreService.path)).thenReturn(collection);
      when(collection.snapshots).thenReturn(snapshots);
      when(snapshot.documents).thenReturn([document]);
      when(document.documentID).thenReturn(todo.id);

      expect(service.todosListener(), emits([todo]));
    });

    test('should delete todos on firestore', () {
      final todoA = new Todo('A');
      final todoB = new Todo('B');
      final auth = new MockFirebaseAuth();
      final firestore = new MockFirestore();
      final collection = new MockCollectionReference();
      final documentA = new MockDocumentReference();
      final documentB = new MockDocumentReference();
      final service = new FirestoreService(auth, firestore);

      when(firestore.collection(FirestoreService.path)).thenReturn(collection);
      when(collection.document(todoA.id)).thenReturn(documentA);
      when(collection.document(todoB.id)).thenReturn(documentB);
      when(documentA.delete()).thenReturn(new Future.value());
      when(documentB.delete()).thenReturn(new Future.value());

      service.deleteTodo([todoA.id, todoB.id]);

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

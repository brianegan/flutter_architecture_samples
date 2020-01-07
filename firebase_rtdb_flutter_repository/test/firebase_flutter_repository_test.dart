// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_flutter_repository/reactive_todos_repository.dart';
import 'package:firebase_flutter_repository/user_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

void main() {
  group('FirebaseUserRepository', () {
    test('should log the user in anonymously', () async {
      final auth = MockFirebaseAuth();
      final repository = FirebaseUserRepository(auth);

      when(auth.signInAnonymously())
          .thenAnswer((_) => Future.value(MockFirebaseUser()));

      final entity = await repository.login();

      expect(entity, TypeMatcher<UserEntity>());
    });
  });

  group('FirebaseReactiveTodosRepository', () {
    test('should send todos to firebase database', () {
      final firebaseDatabase = MockFirebaseDatabase();
      final reference = MockDatabaseReference();
      final collection = MockDatabaseReference();
      final document = MockDatabaseReference();
      final repository = FirebaseReactiveTodosRepository(firebaseDatabase);
      final todo = TodoEntity('A', '1', '', true);

      when(firebaseDatabase.reference()).thenReturn(reference);
      when(reference.child(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.child(todo.id)).thenReturn(document);

      repository.addNewTodo(todo);

      verify(document.set(todo.toJson()));
    });

    test('should update todos on firebase database', () {
      final firebaseDatabase = MockFirebaseDatabase();
      final reference = MockDatabaseReference();
      final collection = MockDatabaseReference();
      final document = MockDatabaseReference();
      final repository = FirebaseReactiveTodosRepository(firebaseDatabase);
      final todo = TodoEntity('A', '1', '', true);

      when(firebaseDatabase.reference()).thenReturn(reference);
      when(reference.child(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.child(todo.id)).thenReturn(document);

      repository.updateTodo(todo);

      verify(document.set(todo.toJson()));
    });

    test('should listen for updates to the collection', () {
      final todo = TodoEntity('A', '1', '', true);
      final firebaseDatabase = MockFirebaseDatabase();
      final reference = MockDatabaseReference();
      final collection = MockDatabaseReference();
      final document = todo.toJson();
      final documentMap = {todo.id: document};
      final event = MockEvent();
      final eventIterator = Stream.fromIterable([event]);
      final data = {'key': todo.id, 'value': documentMap};
      final snapshot = MockDataSnapshot(data);
      final repository = FirebaseReactiveTodosRepository(firebaseDatabase);

      when(firebaseDatabase.reference()).thenReturn(reference);
      when(reference.child(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.onValue).thenAnswer((_) => eventIterator);
      when(event.snapshot).thenReturn(snapshot);
      when(snapshot.key).thenReturn(todo.id); // not used
      when(snapshot.value).thenReturn(documentMap);

      expect(repository.todos(), emits([todo]));
    });

    test('should delete todos on firebaseDatabase', () async {
      final todoA = 'A';
      final todoB = 'B';
      final firebaseDatabase = MockFirebaseDatabase();
      final reference = MockDatabaseReference();
      final collection = MockDatabaseReference();
      final documentA = MockDatabaseReference();
      final documentB = MockDatabaseReference();
      final repository = FirebaseReactiveTodosRepository(firebaseDatabase);

      when(firebaseDatabase.reference()).thenReturn(reference);
      when(reference.child(FirebaseReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.child(todoA)).thenReturn(documentA);
      when(collection.child(todoB)).thenReturn(documentB);
      when(documentA.set(null)).thenAnswer((_) => Future.value());
      when(documentB.set(null)).thenAnswer((_) => Future.value());

      await repository.deleteTodo([todoA, todoB]);

      verify(documentA.set(null));
      verify(documentB.set(null));
    });
  });
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockEvent extends Mock implements Event {}

class MockDataSnapshot extends Mock implements DataSnapshot {
  final Map<dynamic, dynamic> data;

  MockDataSnapshot([this.data]);
}

class MockFirebaseUser extends Mock implements FirebaseUser {}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'dart:async';

import 'package:built_redux_sample/data/file_storage.dart';
import 'package:built_redux_sample/data/todos_repository.dart';
import 'package:built_redux_sample/data/web_client.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

/// We create two Mocks for our Web Service and File Storage. We will use these
/// mock classes to verify the behavior of the TodosService.
class MockFileStorage extends Mock implements FileStorage {}

class MockWebService extends Mock implements WebClient {}

main() {
  group('TodosRepository', () {
    test(
        'should load todos from File Storage if they exist without calling the web service',
        () {
      final fileStorage = new MockFileStorage();
      final webService = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webService,
      );
      final todos = [new Todo("Task")];

      // We'll use our mock throughout the tests to set certain conditions. In
      // this first test, we want to mock out our file storage to return a
      // list of Todos that we define here in our test!
      when(fileStorage.loadTodos()).thenReturn(new Future.value(todos));

      expect(todosService.loadTodos(), completion(todos));
      verifyNever(webService.fetchTodos());
    });

    test(
        'should fetch todos from the Web Service if the file storage throws a synchronous error',
        () async {
      final fileStorage = new MockFileStorage();
      final webService = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webService,
      );
      final todos = [new Todo("Task")];

      // In this instance, we'll ask our Mock to throw an error. When it does,
      // we expect the web service to be called instead.
      when(fileStorage.loadTodos()).thenReturn("");
      when(webService.fetchTodos()).thenReturn(new Future.value(todos));

      // We check that the correct todos were returned, and that the
      // webService.fetchTodos method was in fact called!
      expect(await todosService.loadTodos(), todos);
      verify(webService.fetchTodos());
    });

    test(
        'should fetch todos from the Web Service if the File storage returns an async error',
        () async {
      final fileStorage = new MockFileStorage();
      final webService = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webService,
      );
      final todos = [new Todo("Task")];

      when(fileStorage.loadTodos())
          .thenAnswer((_) => new Future.error("Oh no"));
      when(webService.fetchTodos()).thenReturn(new Future.value(todos));

      expect(await todosService.loadTodos(), todos);
      verify(webService.fetchTodos());
    });

    test('should persist the todos to local disk and the web service', () {
      final fileStorage = new MockFileStorage();
      final webService = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webService,
      );
      final todos = [new Todo("Task")];

      when(fileStorage.saveTodos(todos)).thenReturn(new Future.value("Cool"));
      when(webService.postTodos(todos)).thenReturn(new Future.value("Beans."));

      // In this case, we just want to verify we're correctly persisting to all
      // the storage mechanisms we care about.
      expect(todosService.saveTodos(todos), completes);
      verify(fileStorage.saveTodos(todos));
      verify(webService.postTodos(todos));
    });
  });
}

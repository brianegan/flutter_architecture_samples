import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_repository/todos_repository.dart';

/// We create two Mocks for our Web Service and File Storage. We will use these
/// mock classes to verify the behavior of the TodosRepository.
class MockFileStorage extends Mock implements FileStorage {}

class MockWebService extends Mock implements WebClient {}

main() {
  group('TodosRepository', () {
    List<TodoEntity> createTodos() {
      return [new TodoEntity("Task", "1", "Hallo", false)];
    }

    test(
        'should load todos from File Storage if they exist without calling the web service',
        () {
      final fileStorage = new MockFileStorage();
      final webClient = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final todos = createTodos();

      // We'll use our mock throughout the tests to set certain conditions. In
      // this first test, we want to mock out our file storage to return a
      // list of Todos that we define here in our test!
      when(fileStorage.loadTodos()).thenReturn(new Future.value(todos));

      expect(todosService.loadTodos(), completion(todos));
      verifyNever(webClient.fetchTodos());
    });

    test(
        'should fetch todos from the Web Service if the file storage throws a synchronous error',
        () async {
      final fileStorage = new MockFileStorage();
      final webClient = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final todos = createTodos();

      // In this instance, we'll ask our Mock to throw an error. When it does,
      // we expect the web service to be called instead.
      when(fileStorage.loadTodos()).thenThrow("Uh ohhhh");
      when(webClient.fetchTodos()).thenReturn(new Future.value(todos));

      // We check that the correct todos were returned, and that the
      // webClient.fetchTodos method was in fact called!
      expect(await todosService.loadTodos(), todos);
      verify(webClient.fetchTodos());
    });

    test(
        'should fetch todos from the Web Service if the File storage returns an async error',
        () async {
      final fileStorage = new MockFileStorage();
      final webClient = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final todos = createTodos();

      when(fileStorage.loadTodos())
          .thenAnswer((_) => new Future.error("Oh no"));
      when(webClient.fetchTodos()).thenReturn(new Future.value(todos));

      expect(await todosService.loadTodos(), todos);
      verify(webClient.fetchTodos());
    });

    test('should persist the todos to local disk and the web service', () {
      final fileStorage = new MockFileStorage();
      final webClient = new MockWebService();
      final todosService = new TodosRepository(
        fileStorage: fileStorage,
        webClient: webClient,
      );
      final todos = createTodos();

      when(fileStorage.saveTodos(todos)).thenReturn(new Future.value("Cool"));
      when(webClient.postTodos(todos)).thenReturn(new Future.value("Beans."));

      // In this case, we just want to verify we're correctly persisting to all
      // the storage mechanisms we care about.
      expect(todosService.saveTodos(todos), completes);
      verify(fileStorage.saveTodos(todos));
      verify(webClient.postTodos(todos));
    });
  });
}

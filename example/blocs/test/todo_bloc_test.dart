import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:blocs/src/models/models.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodoBloc', () {
    test('should get the todo from the interactor', () {
      final interactor = new MockTodosInteractor();
      final bloc = new TodoBloc(interactor);
      final todo = new Todo('Hallo');

      when(interactor.todo('2')).thenReturn(new Stream.fromIterable([todo]));

      expect(bloc.todo('2'), emits(todo));
    });

    test('should send deletions to the repo', () async {
      final interactor = new MockTodosInteractor();

      when(interactor.todos).thenReturn(new Stream.fromIterable([[]]));
      when(interactor.deleteTodo('1')).thenReturn(new Future.value());

      final bloc = new TodoBloc(interactor);
      bloc.deleteTodo.add('1');

      verify(interactor.deleteTodo('1'));
    });

    test('should send updates to the repo', () async {
      final interactor = new MockTodosInteractor();
      final update = new Todo('Waaaat');

      when(interactor.todos).thenReturn(new Stream.empty());
      when(interactor.updateTodo(update)).thenReturn(new Future.value());

      final bloc = new TodoBloc(interactor);
      bloc.updateTodo.add(update);

      verify(interactor.updateTodo(update));
    });
  });
}

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:simple_blocs/src/models/models.dart';
import 'package:test/test.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodoBloc', () {
    test('should get the todo from the interactor', () {
      final interactor = MockTodosInteractor();
      final bloc = TodoBloc(interactor);
      final todo = Todo('Hallo');

      when(interactor.todo('2')).thenReturn(Stream.fromIterable([todo]));

      expect(bloc.todo('2'), emits(todo));
    });

    test('should send deletions to the repo', () async {
      final interactor = MockTodosInteractor();
      final bloc = TodoBloc(interactor);

      when(interactor.todos).thenReturn(Stream.fromIterable([[]]));
      when(interactor.deleteTodo('1')).thenReturn(Future.value());

      bloc.deleteTodo('1');

      verify(interactor.deleteTodo('1'));
    });

    test('should send updates to the repo', () async {
      final interactor = MockTodosInteractor();
      final update = Todo('Waaaat');
      final bloc = TodoBloc(interactor);

      when(interactor.todos).thenReturn(Stream.empty());
      when(interactor.updateTodo(update)).thenReturn(Future.value());

      bloc.updateTodo(update);

      verify(interactor.updateTodo(update));
    });
  });
}

import 'package:built_redux_sample/models/models.dart';
import 'package:test/test.dart';

main() {
  group('Selector Tests', () {
    test('should calculate the number of active todos', () {
      final state = new AppState.fromTodos([
        new Todo('a'),
        new Todo('b'),
        new Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ]);

      expect(state.numActiveSelector, 2);
    });

    test('should calculate the number of completed todos', () {
      final state = new AppState.fromTodos([
        new Todo('a'),
        new Todo('b'),
        new Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ]);

      expect(state.numCompletedSelector, 1);
    });

    test('should return all todos if the VisibilityFilter is all', () {
      final todos = [
        new Todo('a'),
        new Todo('b'),
        new Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ];
      final state = new AppState.fromTodos(todos);
      expect(state.activeFilter, VisibilityFilter.all);
      expect(state.filteredTodosSelector, todos);
    });

    test('should return active todos if the VisibilityFilter is active', () {
      final todo1 = new Todo('a');
      final todo2 = new Todo('b');
      final todo3 = new Todo.builder(
        (b) => b
          ..task = 'c'
          ..complete = true,
      );
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = new AppState.fromTodos(todos)
          .rebuild((b) => b.activeFilter = VisibilityFilter.active);

      expect(state.filteredTodosSelector, [todo1, todo2]);
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () {
      final todo1 = new Todo('a');
      final todo2 = new Todo('b');
      final todo3 = new Todo.builder(
        (b) => b
          ..task = 'c'
          ..complete = true,
      );
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final state = new AppState.fromTodos(todos)
          .rebuild((b) => b.activeFilter = VisibilityFilter.completed);

      expect(state.filteredTodosSelector, [todo3]);
    });
  });
}

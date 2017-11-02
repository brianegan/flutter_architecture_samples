import 'package:built_redux_sample/data_model/models.dart';
import 'package:test/test.dart';

main() {
  group('AppState', () {
    test('should check if there are completed todos', () {
      final state = new AppState.fromTodos([
        new Todo('a'),
        new Todo('b'),
        new Todo.builder(
          (b) => b
            ..task = 'c'
            ..complete = true,
        ),
      ]);

      expect(state.hasCompletedTodos, true);
    });

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

      expect(state.numActive, 2);
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

      expect(state.numCompleted, 1);
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

      expect(state.filteredTodos(VisibilityFilter.all), todos);
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
      final state = new AppState.fromTodos(todos);

      expect(state.filteredTodos(VisibilityFilter.active), [
        todo1,
        todo2,
      ]);
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
      final state = new AppState.fromTodos(todos);

      expect(state.filteredTodos(VisibilityFilter.completed), [todo3]);
    });
  });
}

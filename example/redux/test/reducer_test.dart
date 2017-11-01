import 'package:redux/redux.dart';
import 'package:redux_sample/models.dart';
import 'package:redux_sample/actions.dart';
import 'package:redux_sample/reducers.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('State Reducer', () {
    test('should add a todo to the list in response to an AddTodoAction', () {
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState.loading(),
      );
      final todo = new Todo("Hallo");

      store.dispatch(new AddTodoAction(todo));

      expect(store.state.todos, [todo]);
    });

    test('should remove from the list in response to a DeleteTodoAction', () {
      final todo = new Todo("Hallo");
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
          todos: [todo]
        ),
      );

      expect(store.state.todos, [todo]);

      store.dispatch(new DeleteTodoAction(todo.id));

      expect(store.state.todos, []);
    });

    test('should update a todo in response to an UpdateTodoAction', () {
      final todo = new Todo("Hallo");
      final updatedTodo = todo.copyWith(
          task: "Tschüss"
      );
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
          todos: [todo]
        ),
      );

      store.dispatch(new UpdateTodoAction(todo.id, updatedTodo));

      expect(store.state.todos, [updatedTodo]);
    });

    test('should clear completed todos', () {
      final todo1 = new Todo("Hallo");
      final todo2 = new Todo("Tschüss", complete: true);
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
            todos: [todo1, todo2]
        ),
      );

      expect(store.state.todos, [todo1, todo2]);

      store.dispatch(new ClearCompletedAction());

      expect(store.state.todos, [todo1]);
    });

    test('should mark all as completed if some todos are incomplete', () {
      final todo1 = new Todo("Hallo");
      final todo2 = new Todo("Tschüss", complete: true);
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
            todos: [todo1, todo2]
        ),
      );

      expect(store.state.todos, [todo1, todo2]);

      store.dispatch(new ToggleAllAction());

      expect(store.state.todos.every((todo) => todo.complete), isTrue);
    });

    test('should mark all as incomplete if all todos are complete', () {
      final todo1 = new Todo("Hallo", complete: true);
      final todo2 = new Todo("Tschüss", complete: true);
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
            todos: [todo1, todo2]
        ),
      );

      expect(store.state.todos, [todo1, todo2]);

      store.dispatch(new ToggleAllAction());

      expect(store.state.todos.every((todo) => !todo.complete), isTrue);
    });

    test('should update the VisibilityFilter', () {
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
          activeFilter: VisibilityFilter.active
        ),
      );

      store.dispatch(new UpdateFilterAction(VisibilityFilter.completed));

      expect(store.state.activeFilter, VisibilityFilter.completed);
    });

    test('should update the AppTab', () {
      final store = new Store<AppState>(
        stateReducer,
        initialState: new AppState(
          activeTab: AppTab.todos
        ),
      );

      store.dispatch(new UpdateTabAction(AppTab.stats));

      expect(store.state.activeTab, AppTab.stats);
    });
  });
}

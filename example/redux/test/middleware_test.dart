import 'package:redux/redux.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/reducers/app_state_reducer.dart';
import 'package:redux_sample/middleware/store_todos_middleware.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos_repository/todos_repository.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

main() {
  group('Save State Middleware', () {
    test('should load the todos in response to a LoadTodosAction', () {
      final repository = new MockTodosRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(repository),
      );
      final todos = [
        new Todo("Moin"),
      ];

      when(repository.loadTodos()).thenReturn(new Future.value(todos));

      store.dispatch(new LoadTodosAction());

      verify(repository.loadTodos());
    });

    test('should save the state on every update action', () {
      final repository = new MockTodosRepository();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(repository),
      );
      final todo = new Todo("Hallo");

      store.dispatch(new AddTodoAction(todo));
      store.dispatch(new ClearCompletedAction());
      store.dispatch(new ToggleAllAction());
      store.dispatch(new TodosLoadedAction([new Todo("Hi")]));
      store.dispatch(new ToggleAllAction());
      store.dispatch(new UpdateTodoAction("", new Todo("")));
      store.dispatch(new DeleteTodoAction(""));

      verify(repository.saveTodos(any)).called(7);
    });
  });
}

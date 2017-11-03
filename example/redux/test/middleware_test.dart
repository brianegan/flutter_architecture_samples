import 'package:redux/redux.dart';
import 'package:redux_sample/data/todos_service.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/reducers/app_state_reducer.dart';
import 'package:redux_sample/middleware/store_todos_middleware.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTodosService extends Mock implements TodosService {}

main() {
  group('Save State Middleware', () {
    test('should load the todos in response to a LoadTodosAction', () {
      final service = new MockTodosService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(service),
      );
      final todos = [
        new Todo("Moin"),
      ];

      when(service.loadTodos()).thenReturn(new Future.value(todos));

      store.dispatch(new LoadTodosAction());

      verify(service.loadTodos());
    });

    test('should save the state on every update action', () {
      final service = new MockTodosService();
      final store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createStoreTodosMiddleware(service),
      );
      final todo = new Todo("Hallo");

      store.dispatch(new AddTodoAction(todo));
      store.dispatch(new ClearCompletedAction());
      store.dispatch(new ToggleAllAction());
      store.dispatch(new TodosLoadedAction([new Todo("Hi")]));
      store.dispatch(new ToggleAllAction());
      store.dispatch(new UpdateTodoAction("", new Todo("")));

      verify(service.saveTodos(any)).called(6);
    });
  });
}

import 'package:built_redux_sample/models/models.dart';
import 'package:quiver/core.dart';

List<Todo> todosSelector(AppState state) => state.todos.toList();

VisibilityFilter activeFilterSelector(AppState state) => state.activeFilter;

AppTab activeTabSelector(AppState state) => state.activeTab;

bool isLoadingSelector(AppState state) => state.isLoading;

bool allCompleteSelector(List<Todo> todos) =>
    todos.every((todo) => todo.complete);

int numActiveSelector(List<Todo> todos) =>
    todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

int numCompletedSelector(List<Todo> todos) =>
    todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

List<Todo> filteredTodosSelector(
  List<Todo> todos,
  VisibilityFilter activeFilter,
) {
  return todos.where((todo) {
    if (activeFilter == VisibilityFilter.all) {
      return true;
    } else if (activeFilter == VisibilityFilter.active) {
      return !todo.complete;
    } else if (activeFilter == VisibilityFilter.completed) {
      return todo.complete;
    }
  }).toList();
}

Optional<Todo> todoSelector(List<Todo> todos, String id) {
  try {
    return new Optional.of(todos.firstWhere((todo) => todo.id == id));
  } catch (e) {
    return new Optional.absent();
  }
}

import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/presentation/todo_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class FilteredTodos extends StoreConnector<AppState, AppActions, List<Todo>> {
  FilteredTodos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, List<Todo> state, AppActions actions) {
    return new TodoList(
      todos: state,
      onCheckboxChanged: (todo, complete) {
        actions.updateTodoAction(new UpdateTodoActionPayload(
            todo.id, todo.rebuild((b) => b..complete = complete)));
      },
      onRemove: (todo) {
        actions.deleteTodoAction(todo.id);
      },
      onUndoRemove: (todo) {
        actions.addTodoAction(todo);
      },
    );
  }

  @override
  List<Todo> connect(AppState state) => state.filteredTodosSelector;
}

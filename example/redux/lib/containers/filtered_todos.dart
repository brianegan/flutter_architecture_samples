import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:redux_sample/widgets/todo_list.dart';

class FilteredTodosViewModel {
  final List<Todo> todos;
  final bool loading;
  final Function(Todo, bool) onCheckboxChanged;
  final Function(Todo) onRemove;
  final Function(Todo) onUndoRemove;

  FilteredTodosViewModel({
    @required this.todos,
    @required this.loading,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  });

  static FilteredTodosViewModel fromStore(Store<AppState> store) {
    return new FilteredTodosViewModel(
      todos: filteredTodosSelector(
        todosSelector(store.state),
        activeFilterSelector(store.state),
      ),
      loading: store.state.isLoading,
      onCheckboxChanged: (todo, complete) {
        store.dispatch(new UpdateTodoAction(
          todo.id,
          todo.copyWith(complete: !todo.complete),
        ));
      },
      onRemove: (todo) {
        store.dispatch(new DeleteTodoAction(todo.id));
      },
      onUndoRemove: (todo) {
        store.dispatch(new AddTodoAction(todo));
      },
    );
  }
}

class FilteredTodos extends StatelessWidget {
  FilteredTodos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FilteredTodosViewModel>(
      converter: FilteredTodosViewModel.fromStore,
      builder: (context, vm) {
        return new TodoList(
          todos: vm.todos,
          onCheckboxChanged: vm.onCheckboxChanged,
          onRemove: vm.onRemove,
          onUndoRemove: vm.onUndoRemove,
        );
      },
    );
  }
}

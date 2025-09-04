import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/presentation/todo_list.dart';
import 'package:redux_sample/selectors/selectors.dart';

class FilteredTodos extends StatelessWidget {
  const FilteredTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return TodoList(
          todos: vm.todos,
          onCheckboxChanged: vm.onCheckboxChanged,
          onRemove: vm.onRemove,
          onUndoRemove: vm.onUndoRemove,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Todo> todos;
  final bool loading;
  final void Function(Todo, bool?) onCheckboxChanged;
  final void Function(Todo) onRemove;
  final void Function(Todo) onUndoRemove;

  _ViewModel({
    required this.todos,
    required this.loading,
    required this.onCheckboxChanged,
    required this.onRemove,
    required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      todos: filteredTodosSelector(
        todosSelector(store.state),
        activeFilterSelector(store.state),
      ),
      loading: store.state.isLoading,
      onCheckboxChanged: (todo, complete) {
        store.dispatch(
          UpdateTodoAction(todo.id, todo.copyWith(complete: !todo.complete)),
        );
      },
      onRemove: (todo) {
        store.dispatch(DeleteTodoAction(todo.id));
      },
      onUndoRemove: (todo) {
        store.dispatch(AddTodoAction(todo));
      },
    );
  }
}

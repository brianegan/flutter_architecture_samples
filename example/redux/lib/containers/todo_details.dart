import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:redux_sample/widgets/details_screen.dart';

class TodoDetailsViewModel {
  final Todo todo;
  final Function onDelete;
  final Function(bool) toggleCompleted;

  TodoDetailsViewModel({
    @required this.todo,
    @required this.onDelete,
    @required this.toggleCompleted,
  });

  factory TodoDetailsViewModel.from(Store<AppState> store, String id) {
    final todo = todoSelector(todosSelector(store.state), id).value;

    return new TodoDetailsViewModel(
      todo: todo,
      onDelete: () => store.dispatch(new DeleteTodoAction(todo.id)),
      toggleCompleted: (isComplete) {
        store.dispatch(new UpdateTodoAction(
          todo.id,
          todo.copyWith(complete: isComplete),
        ));
      },
    );
  }
}

class TodoDetails extends StatelessWidget {
  final String id;

  TodoDetails({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, TodoDetailsViewModel>(
      ignoreChange: (state) => !todoSelector(state.todos, id).isPresent,
      converter: (Store<AppState> store) {
        return new TodoDetailsViewModel.from(store, id);
      },
      builder: (context, vm) {
        return new DetailsScreen(
          todo: vm.todo,
          onDelete: vm.onDelete,
          toggleCompleted: vm.toggleCompleted,
        );
      },
    );
  }
}

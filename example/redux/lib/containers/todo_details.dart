import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/actions.dart';
import 'package:redux_sample/models.dart';

class TodoDetailsViewModel {
  final Todo todo;
  final Function onDelete;
  final Function(bool) toggleCompleted;

  TodoDetailsViewModel({
    @required this.todo,
    @required this.onDelete,
    @required this.toggleCompleted,
  });
}

class TodoDetails extends StatelessWidget {
  final String id;
  final ViewModelBuilder<TodoDetailsViewModel> builder;

  TodoDetails({
    Key key,
    @required this.id,
    @required this.builder,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, TodoDetailsViewModel>(
      ignoreChange: (state) =>
          state.todos.where((todo) => todo.id == id).isNotEmpty,
      converter: (Store<AppState> store) {
        final todo = store.state.todos.firstWhere((todo) => todo.id == id);

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
      },
      builder: builder,
    );
  }
}

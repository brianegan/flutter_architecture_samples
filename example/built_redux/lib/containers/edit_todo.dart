import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/widgets/add_edit_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class EditTodo
    extends StoreConnector<AppState, AppStateBuilder, AppActions, Null> {
  final Todo todo;

  EditTodo({this.todo, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, _, AppActions actions) {
    return new AddEditScreen(
      isEditing: true,
      onSave: (task, note) {
        actions.updateTodoAction(new UpdateTodoActionPayload(
            todo.id,
            (todo.toBuilder()
                  ..task = task
                  ..note = note)
                .build()));
      },
      todo: todo,
    );
  }

  @override
  connect(AppState state) {}
}

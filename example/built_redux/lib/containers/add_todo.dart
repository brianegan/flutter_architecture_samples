import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/widgets/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

class AddTodo
    extends StoreConnector<AppState, AppStateBuilder, AppActions, Null> {
  AddTodo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, Null ignored, AppActions actions) {
    return new AddEditScreen(
        isEditing: false,
        onSave: (String task, String note) {
          actions.addTodoAction(new Todo.builder((b) {
            return b
              ..task = task
              ..note = note;
          }));
        });
  }

  @override
  connect(AppState state) {}
}

import 'package:flutter/material.dart';
import 'package:redux_sample/actions.dart';
import 'package:redux_sample/models.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_sample/widgets/add_edit_screen.dart';

class AddTodo extends StatelessWidget {
  AddTodo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnSaveCallback>(
      converter: (Store<AppState> store) {
        return (task, note) {
          store.dispatch(new AddTodoAction(new Todo(
            task,
            note: note,
          )));
        };
      },
      builder: (BuildContext context, OnSaveCallback onSave) {
        return new AddEditScreen(
          onSave: onSave,
          isEditing: false,
        );
      },
    );
  }
}

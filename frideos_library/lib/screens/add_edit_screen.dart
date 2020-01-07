import 'dart:async';

import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/app_state.dart';
import 'package:frideos_library/models/models.dart';

class AddEditScreen extends StatefulWidget {
  // Set to false by default to show the 'add todo'.
  // On 'detail screen', push this screen with isEditing set
  // to 'true', so that the fab will be used to edit an existing todo.
  final bool isEditing;

  AddEditScreen({
    Key key,
    this.isEditing = false,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _task;
  String _note;

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of<AppState>(context).todosBloc;
    var isEditing = widget.isEditing;

    return ValueBuilder<Todo>(
      streamed: bloc.currentTodo,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing
                ? ArchSampleLocalizations.of(context).editTodo
                : ArchSampleLocalizations.of(context).addTodo,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            autovalidate: false,
            onWillPop: () {
              return Future(() => true);
            },
            child: ListView(
              children: [
                TextFormField(
                  initialValue: isEditing ? snapshot.data.task : '',
                  key: ArchSampleKeys.taskField,
                  autofocus: isEditing ? false : true,
                  style: Theme.of(context).textTheme.headline,
                  decoration: InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).newTodoHint,
                  ),
                  validator: (val) => val.trim().isEmpty
                      ? ArchSampleLocalizations.of(context).emptyTodoError
                      : null,
                  onSaved: (value) => _task = value,
                ),
                TextFormField(
                  initialValue: isEditing ? snapshot.data.note : '',
                  key: ArchSampleKeys.noteField,
                  maxLines: 10,
                  style: Theme.of(context).textTheme.subhead,
                  decoration: InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).notesHint,
                  ),
                  onSaved: (value) => _note = value,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: isEditing
              ? ArchSampleKeys.saveTodoFab
              : ArchSampleKeys.saveNewTodo,
          tooltip: isEditing
              ? ArchSampleLocalizations.of(context).saveChanges
              : ArchSampleLocalizations.of(context).addTodo,
          child: Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () {
            final form = formKey.currentState;
            if (form.validate()) {
              form.save();

              bloc.addEdit(isEditing, _task, _note);

              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

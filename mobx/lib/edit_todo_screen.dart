import 'package:flutter/material.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:todos_app_core/todos_app_core.dart';

class EditTodoScreen extends StatefulWidget {
  final void Function() onEdit;
  final Todo todo;

  const EditTodoScreen({
    @required this.todo,
    @required this.onEdit,
  }) : super(key: ArchSampleKeys.editTodoScreen);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArchSampleLocalizations.of(context).editTodo)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                key: ArchSampleKeys.taskField,
                initialValue: widget.todo.task,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).newTodoHint,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? ArchSampleLocalizations.of(context).emptyTodoError
                      : null;
                },
                onSaved: (value) => widget.todo.task = value,
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                initialValue: widget.todo.note ?? '',
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
                maxLines: 10,
                onSaved: (value) => widget.todo.note = value,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveTodoFab,
        tooltip: ArchSampleLocalizations.of(context).saveChanges,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onEdit();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

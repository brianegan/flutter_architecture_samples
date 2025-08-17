import 'package:flutter/material.dart';
import 'package:signals_sample/todo.dart';
import 'package:todos_app_core/todos_app_core.dart';

class EditTodoScreen extends StatefulWidget {
  final void Function() onEdit;
  final Todo todo;

  const EditTodoScreen({required this.todo, required this.onEdit})
    : super(key: ArchSampleKeys.editTodoScreen);

  @override
  EditTodoScreenState createState() => EditTodoScreenState();
}

class EditTodoScreenState extends State<EditTodoScreen> {
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
                initialValue: widget.todo.task.value,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).newTodoHint,
                ),
                validator: (val) {
                  return val == null || val.trim().isEmpty
                      ? ArchSampleLocalizations.of(context).emptyTodoError
                      : null;
                },
                onSaved: (value) => widget.todo.task.value = value ?? '',
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                initialValue: widget.todo.note.value,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
                maxLines: 10,
                onSaved: (value) => widget.todo.note.value = value ?? '',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveTodoFab,
        tooltip: ArchSampleLocalizations.of(context).saveChanges,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.onEdit();
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

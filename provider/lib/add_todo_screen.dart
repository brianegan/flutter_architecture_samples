import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'models.dart';
import 'todo_list_model.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen() : super(key: ArchSampleKeys.addTodoScreen);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleEditingController = TextEditingController();
  final _notesEditingController = TextEditingController();

  @override
  void dispose() {
    _titleEditingController.dispose();
    _notesEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addTodo),
      ),
      body: Form(
        key: _formKey,
        autovalidate: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                key: ArchSampleKeys.taskField,
                controller: _titleEditingController,
                decoration: InputDecoration(
                  hintText: localizations.newTodoHint,
                ),
                style: textTheme.headline,
                autofocus: true,
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyTodoError
                      : null;
                },
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                controller: _notesEditingController,
                style: textTheme.subhead,
                decoration: InputDecoration(hintText: localizations.notesHint),
                maxLines: 10,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveNewTodo,
        tooltip: localizations.addTodo,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Provider.of<TodoListModel>(context, listen: false).addTodo(Todo(
              _titleEditingController.text,
              note: _notesEditingController.text,
            ));
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

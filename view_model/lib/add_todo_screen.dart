import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'todo.dart';

class AddTodoScreen extends StatefulWidget {
  final void Function(Todo) onAdd;

  const AddTodoScreen({
    super.key = ArchSampleKeys.addTodoScreen,
    required this.onAdd,
  });

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.addTodo)),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                key: ArchSampleKeys.taskField,
                controller: _taskController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: localizations.newTodoHint,
                ),
                style: textTheme.titleLarge,
                validator: (value) {
                  return value == null || value.trim().isEmpty
                      ? localizations.emptyTodoError
                      : null;
                },
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                controller: _notesController,
                decoration: InputDecoration(hintText: localizations.notesHint),
                maxLines: 10,
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveNewTodo,
        tooltip: localizations.addTodo,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            widget.onAdd(
              Todo(_taskController.text, note: _notesController.text),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

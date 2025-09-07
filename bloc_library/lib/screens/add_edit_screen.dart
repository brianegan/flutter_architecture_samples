import 'package:bloc_library/models/models.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

typedef OnSaveCallback = void Function(String task, String note);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Todo? todo;

  const AddEditScreen({
    super.key = ArchSampleKeys.addTodoScreen,
    required this.onSave,
    required this.isEditing,
    this.todo,
  });

  @override
  AddEditScreenState createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _task;
  late String _note;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? localizations.editTodo : localizations.addTodo),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.todo!.task : '',
                key: ArchSampleKeys.taskField,
                autofocus: !isEditing,
                style: textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: localizations.newTodoHint,
                ),
                validator: (val) {
                  return val != null && val.trim().isEmpty
                      ? localizations.emptyTodoError
                      : null;
                },
                onSaved: (value) => _task = value ?? '',
              ),
              TextFormField(
                initialValue: isEditing ? widget.todo!.note : '',
                key: ArchSampleKeys.noteField,
                maxLines: 10,
                style: textTheme.titleMedium,
                decoration: InputDecoration(hintText: localizations.notesHint),
                onSaved: (value) => _note = value ?? '',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: isEditing
            ? ArchSampleKeys.saveTodoFab
            : ArchSampleKeys.saveNewTodo,
        tooltip: isEditing ? localizations.saveChanges : localizations.addTodo,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.onSave(_task, _note);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

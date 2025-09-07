import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class AddEditScreen extends StatefulWidget {
  final Todo? todo;
  final void Function(Todo)? addTodo;
  final void Function(Todo)? updateTodo;

  const AddEditScreen({
    super.key = ArchSampleKeys.addTodoScreen,
    this.todo,
    this.addTodo,
    this.updateTodo,
  });

  @override
  AddEditScreenState createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String _task;
  late String _note;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Scaffold(
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
          autovalidateMode: AutovalidateMode.always,
          canPop: true,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.todo!.task : '',
                key: ArchSampleKeys.taskField,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).newTodoHint,
                ),
                validator: (val) => val != null && val.trim().isEmpty
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
                onSaved: (value) => _task = value ?? '',
              ),
              TextFormField(
                initialValue: isEditing ? widget.todo!.note : '',
                key: ArchSampleKeys.noteField,
                maxLines: 10,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
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
        tooltip: isEditing
            ? ArchSampleLocalizations.of(context).saveChanges
            : ArchSampleLocalizations.of(context).addTodo,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form!.validate()) {
            form.save();

            if (isEditing) {
              widget.updateTodo!(
                widget.todo!.copyWith(task: _task, note: _note),
              );
            } else {
              widget.addTodo!(Todo(_task, note: _note));
            }

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';

class AddEditScreen extends StatefulWidget {
  final String? todoId;

  const AddEditScreen({super.key = ArchSampleKeys.addTodoScreen, this.todoId});

  @override
  AddEditScreenState createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _task;
  late String _note;

  bool get isEditing => widget.todoId != null && widget.todoId!.isNotEmpty;

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
          autovalidateMode: AutovalidateMode.always,
          canPop: true,
          child: ScopedModelDescendant<TodoListModel>(
            builder:
                (BuildContext context, Widget? child, TodoListModel model) {
                  final task = isEditing
                      ? model.todoById(widget.todoId!)
                      : null;

                  return ListView(
                    children: [
                      TextFormField(
                        initialValue: task?.task ?? '',
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
                        initialValue: task?.note ?? '',
                        key: ArchSampleKeys.noteField,
                        maxLines: 10,
                        style: textTheme.titleMedium,
                        decoration: InputDecoration(
                          hintText: localizations.notesHint,
                        ),
                        onSaved: (value) => _note = value ?? '',
                      ),
                    ],
                  );
                },
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
          final form = _formKey.currentState;
          if (form!.validate()) {
            form.save();

            var model = TodoListModel.of(context);
            if (isEditing) {
              var todo = model.todoById(widget.todoId!);
              model.updateTodo(todo!.copy(task: _task, note: _note));
            } else {
              model.addTodo(Todo(_task, note: _note));
            }

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

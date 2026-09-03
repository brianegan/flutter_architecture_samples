import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';

import 'todo_list_view_model.dart';

class EditTodoScreen extends StatefulWidget {
  final VoidCallback onEdit;
  final TodosRepository repository;
  final String todoId;

  const EditTodoScreen({
    required this.onEdit,
    required this.repository,
    required this.todoId,
  }) : super(key: ArchSampleKeys.editTodoScreen);

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen>
    with ViewModelStateMixin<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _note;
  late String _task;

  TodoListViewModel get todoListViewModel =>
      viewModelBinding.read(todoListViewModelSpec(widget.repository));

  @override
  void initState() {
    super.initState();
    final todo = todoListViewModel.todoById(widget.todoId)!;
    _note = todo.note;
    _task = todo.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ArchSampleLocalizations.of(context).editTodo)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                key: ArchSampleKeys.taskField,
                initialValue: _task,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).newTodoHint,
                ),
                validator: (value) {
                  return value == null || value.trim().isEmpty
                      ? ArchSampleLocalizations.of(context).emptyTodoError
                      : null;
                },
                onSaved: (value) => _task = value ?? '',
              ),
              TextFormField(
                key: ArchSampleKeys.noteField,
                initialValue: _note,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
                maxLines: 10,
                onSaved: (value) => _note = value ?? '',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.saveTodoFab,
        tooltip: ArchSampleLocalizations.of(context).saveChanges,
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          _formKey.currentState!.save();
          final todo = todoListViewModel.todoById(widget.todoId);
          if (todo == null) return;
          unawaited(
            todoListViewModel.updateTodo(
              todo.copyWith(task: _task, note: _note),
            ),
          );
          widget.onEdit();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

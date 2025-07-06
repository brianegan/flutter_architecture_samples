// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/widgets/typedefs.dart';

class AddEditScreen extends StatefulWidget {
  final Todo? todo;
  final TodoAdder addTodo;
  final TodoUpdater updateTodo;

  const AddEditScreen({
    super.key = ArchSampleKeys.addTodoScreen,
    required this.addTodo,
    required this.updateTodo,
    this.todo,
  });

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _task;
  String? _note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? ArchSampleLocalizations.of(context).editTodo
            : ArchSampleLocalizations.of(context).addTodo),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          canPop: true,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.todo != null ? widget.todo!.task : '',
                key: ArchSampleKeys.taskField,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).newTodoHint),
                validator: (val) => val?.trim().isEmpty ?? true
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
                onSaved: (value) => _task = value,
              ),
              TextFormField(
                initialValue: widget.todo != null ? widget.todo!.note : '',
                key: ArchSampleKeys.noteField,
                maxLines: 10,
                style: Theme.of(context).textTheme.bodyMedium,
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
          child: Icon(Icons.check),
          onPressed: () {
            final form = _formKey.currentState!;

            if (form.validate()) {
              form.save();

              final task = _task!;
              final note = _note!;

              if (isEditing) {
                widget.updateTodo(widget.todo!, task: task, note: note);
              } else {
                widget.addTodo(Todo(
                  task,
                  note: note,
                ));
              }

              Navigator.pop(context);
            }
          }),
    );
  }

  bool get isEditing => widget.todo != null;
}

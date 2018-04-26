// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class AddEditScreen extends StatelessWidget {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> taskKey =
      GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> noteKey =
      GlobalKey<FormFieldState<String>>();

  final Todo todo;
  final Function(Todo) addTodo;
  final Function(Todo) updateTodo;

  AddEditScreen({
    Key key,
    this.todo,
    this.addTodo,
    this.updateTodo,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  Widget build(BuildContext context) {
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
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: ListView(
            children: [
              TextFormField(
                initialValue: todo != null ? todo.task : '',
                key: taskKey,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).newTodoHint,
                ),
                validator: (val) => val.trim().isEmpty
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
              ),
              TextFormField(
                initialValue: todo != null ? todo.note : '',
                key: noteKey,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key:
            isEditing ? ArchSampleKeys.saveTodoFab : ArchSampleKeys.saveNewTodo,
        tooltip: isEditing
            ? ArchSampleLocalizations.of(context).saveChanges
            : ArchSampleLocalizations.of(context).addTodo,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            final task = taskKey.currentState.value;
            final note = noteKey.currentState.value;

            if (isEditing) {
              updateTodo(todo.copyWith(task: task, note: note));
            } else {
              addTodo(Todo(
                task,
                note: note,
              ));
            }

            Navigator.pop(context);
          }
        },
      ),
    );
  }

  bool get isEditing => todo != null;
}

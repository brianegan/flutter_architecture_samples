// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async' show Future;
import 'package:flutter/material.dart';

import 'package:flutter_architecture_samples/flutter_architecture_samples.dart' show ArchSampleKeys, ArchSampleLocalizations;

/// The 'View' should know nothing of the 'Model.'
/// The 'View' only knows how to 'talk to' the Controller.
import 'package:mvc/src/Controller.dart' show Con;

class AddEditScreen extends StatelessWidget {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> taskKey =
      GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> noteKey =
      GlobalKey<FormFieldState<String>>();

  final String todoId;

  AddEditScreen({
    Key key,
    this.todoId,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  final Con _con = Con.con;

  @override
  Widget build(BuildContext context) {
    /// Return the 'universally recognized' Map object.
    /// The data will only be known through the use of Map objects.
    Map<String, Object> todo = _con.todoById(todoId);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? ArchSampleLocalizations.of(context).editTodo
            : ArchSampleLocalizations.of(context).addTodo),
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
                initialValue: todo['task'] ?? '',
                key: taskKey,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).newTodoHint),
                validator: (val) => val.trim().isEmpty
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
              ),
              TextFormField(
                initialValue: todo['note'] ?? '',
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
            todo['task'] = taskKey.currentState.value;
            todo['note'] = noteKey.currentState.value;
            _con.update(todo);
            Navigator.pop(context, todo);
          }
        },
      ),
    );
  }

  bool get isEditing => todoId != null;
}

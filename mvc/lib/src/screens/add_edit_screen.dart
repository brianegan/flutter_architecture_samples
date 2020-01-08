// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async' show Future;
import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart'
    show ArchSampleKeys, ArchSampleLocalizations;

/// The 'View' should know nothing of the 'Model.'
/// The 'View' only knows how to 'talk to' the Controller.
import 'package:mvc/src/Controller.dart' show Con;

class AddEditScreen extends StatefulWidget {
  final String todoId;

  AddEditScreen({
    Key key,
    this.todoId,
  }) : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Con _con = Con.con;
  String _task;
  String _note;

  @override
  Widget build(BuildContext context) {
    /// Return the 'universally recognized' Map object.
    /// The data will only be known through the use of Map objects.
    final todo = _con.todoById(widget.todoId);

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
                key: ArchSampleKeys.taskField,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).newTodoHint),
                validator: (val) => val.trim().isEmpty
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
                onSaved: (value) => _task = value,
              ),
              TextFormField(
                initialValue: todo['note'] ?? '',
                key: ArchSampleKeys.noteField,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
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
        key:
            isEditing ? ArchSampleKeys.saveTodoFab : ArchSampleKeys.saveNewTodo,
        tooltip: isEditing
            ? ArchSampleLocalizations.of(context).saveChanges
            : ArchSampleLocalizations.of(context).addTodo,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();
            todo['task'] = _task;
            todo['note'] = _note;
            if (isEditing) {
              _con.update(todo);
            } else {
              _con.addTodo(todo);
            }
            Navigator.pop(context, todo);
          }
        },
      ),
    );
  }

  bool get isEditing => widget.todoId != null;
}

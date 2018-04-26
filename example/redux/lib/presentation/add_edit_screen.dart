// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:redux_sample/models/models.dart';

typedef OnSaveCallback = Function(String task, String note);

class AddEditScreen extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _taskKey =
      GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _noteKey =
      GlobalKey<FormFieldState<String>>();

  final bool isEditing;
  final Function(String, String) onSave;
  final Todo todo;

  AddEditScreen(
      {Key key, @required this.onSave, @required this.isEditing, this.todo})
      : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? localizations.editTodo : localizations.addTodo,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? todo.task : '',
                key: _taskKey,
                autofocus: !isEditing,
                style: textTheme.headline,
                decoration: InputDecoration(
                  hintText: localizations.newTodoHint,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyTodoError
                      : null;
                },
              ),
              TextFormField(
                initialValue: isEditing ? todo.note : '',
                key: _noteKey,
                maxLines: 10,
                style: textTheme.subhead,
                decoration: InputDecoration(
                  hintText: localizations.notesHint,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? localizations.saveChanges : localizations.addTodo,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            onSave(
              _taskKey.currentState.value,
              _noteKey.currentState.value,
            );

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

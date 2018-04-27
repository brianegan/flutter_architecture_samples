import 'package:flutter/material.dart';

import 'package:dartea/dartea.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/details/details.dart' as details;
import 'package:mvu/edit/edit.dart' as edit;

NavigatorState _navigator;

void init(BuildContext context) {
  _navigator = Navigator.of(context);
}

Cmd<T> goToDetailsScreen<T>(TodoModel todo) =>
    Cmd.ofAction<T>(() => _navigator.push(new MaterialPageRoute(
        builder: (_) => details.createProgram().buildWith(initArg: todo))));

Cmd<T> goToEditTodoScreen<T>(TodoModel todo) =>
    Cmd.ofAction<T>(() => _navigator.push(new MaterialPageRoute(
        builder: (_) =>
            edit.createProgram().buildWith(initArg: todo.toEntity()))));

Cmd<T> goToCreateNewScreen<T>() => Cmd.ofAction<T>(() => _navigator.push(
    new MaterialPageRoute(builder: (_) => edit.createProgram().buildWith())));

Cmd<T> goBack<T>() => Cmd.ofAction<T>(() => _navigator.pop());

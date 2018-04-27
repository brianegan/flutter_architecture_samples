library details;

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

import 'package:dartea/dartea.dart';
import 'package:mvu/details/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/common/repository_commands.dart' as repo;
import 'package:mvu/common/router.dart' as router;

part 'state.dart';
part 'view.dart';

Program<TodoModel, DetailsModel, DetailsMessage> createProgram() =>
    new Program(init, update, view, subscribe: _repoSubscription);

Cmd<DetailsMessage> _repoSubscription(DetailsModel _) =>
    repo.subscribe((event) {
      if (event is repo.OnTodoAdded) {
        return null;
      }
      if (event is repo.OnTodoChanged) {
        return OnTodoChanged(event.entity);
      }
      if (event is repo.OnTodoRemoved) {
        return OnTodoRemoved(event.entity);
      }
    });

library details;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'package:dartea/dartea.dart';
import 'package:mvu/details/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/common/repository_commands.dart';
import 'package:mvu/common/router.dart' as router;

part 'state.dart';
part 'view.dart';

Program<DetailsModel, DetailsMessage, StreamSubscription<RepositoryEvent>>
    createProgram(CmdRepository repo, TodoModel todo) => Program(
        () => init(todo), (msg, model) => update(repo, msg, model), view,
        subscription: (s, d, m) => _repoSubscription(repo, s, d, m));

StreamSubscription<RepositoryEvent> _repoSubscription(
    CmdRepository repo,
    StreamSubscription<RepositoryEvent> currentSub,
    Dispatch<DetailsMessage> dispatch,
    DetailsModel model) {
  if (currentSub != null) {
    return currentSub;
  }
  final sub = repo.events.listen((event) {
    if (event is RepoOnTodoChanged) {
      dispatch(OnTodoChanged(event.entity));
    }
    if (event is RepoOnTodoRemoved) {
      dispatch(OnTodoRemoved(event.entity));
    }
  });
  return sub;
}

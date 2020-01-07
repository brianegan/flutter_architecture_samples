library home;

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:dartea/dartea.dart';
import 'package:mvu/localization.dart';
import 'package:mvu/home/types.dart';
import 'package:mvu/stats/types.dart';
import 'package:mvu/todos/types.dart';
import 'package:mvu/common/repository_commands.dart';
import 'package:mvu/todos/todos.dart' as todos;
import 'package:mvu/stats/stats.dart' as stats;
import 'package:mvu/common/router.dart' as router;
import 'package:mvu/common/snackbar.dart' as snackbar;

part 'state.dart';
part 'view.dart';

Program<HomeModel, HomeMessage, StreamSubscription<RepositoryEvent>>
    createProgram(AppTab initTab) => Program(() => init(initTab), update, view,
        subscription: _repoSubscription);

StreamSubscription<RepositoryEvent> _repoSubscription(
    StreamSubscription<RepositoryEvent> currentSub,
    Dispatch<HomeMessage> dispatch,
    HomeModel model) {
  if (currentSub != null) {
    return currentSub;
  }
  final sub = repoCmds.events.listen((event) {
    if (event is RepoOnTodoAdded) {
      dispatch(OnNewTodoCreated(event.entity));
    }
    if (event is RepoOnTodoChanged) {
      dispatch(TodosMsg(OnTodoItemChanged(updated: event.entity)));
    }
    if (event is RepoOnTodoRemoved) {
      dispatch(TodosMsg(OnTodoItemChanged(removed: event.entity)));
    }
  });
  return sub;
}

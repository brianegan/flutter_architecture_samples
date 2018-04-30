library home;

import 'package:flutter/material.dart';

import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

import 'package:dartea/dartea.dart';
import 'package:mvu/localization.dart';
import 'package:mvu/home/types.dart';
import 'package:mvu/todos/types.dart';
import 'package:mvu/common/repository_commands.dart';
import 'package:mvu/todos/todos.dart' as todos;
import 'package:mvu/stats/stats.dart' as stats;
import 'package:mvu/common/router.dart' as router;
import 'package:mvu/common/snackbar.dart' as snackbar;

part 'state.dart';
part 'view.dart';

Program<AppTab, HomeModel, HomeMessage> createProgram() => new Program(init, update, view, subscribe: _repoSubscription);

Cmd<HomeMessage> _repoSubscription(HomeModel _) =>
    repoCmds.subscribe((event) {
      if (event is OnTodoAdded) {
        return TodosMsg(OnTodoItemChanged(created: event.entity));
      }
      if (event is OnTodoChanged) {
        return TodosMsg(OnTodoItemChanged(updated: event.entity));
      }
      if (event is OnTodoRemoved) {
        return TodosMsg(OnTodoItemChanged(removed: event.entity));
      }
    });
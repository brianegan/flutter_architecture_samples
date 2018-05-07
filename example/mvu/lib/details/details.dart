library details;

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

import 'package:dartea/dartea.dart';
import 'package:mvu/details/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/common/repository_commands.dart';
import 'package:mvu/common/router.dart' as router;

part 'state.dart';
part 'view.dart';

Program<TodoModel, DetailsModel, DetailsMessage> createProgram(
        CmdRepository repo) =>
    new Program(init, (msg, model) => update(repo, msg, model), view,
        subscribe: (_) => _repoSubscription(repo));

Cmd<DetailsMessage> _repoSubscription(CmdRepository repo) =>
    repo.subscribe((event) {
      if (event is RepoOnTodoAdded) {
        return null;
      }
      if (event is RepoOnTodoChanged) {
        return OnTodoChanged(event.entity);
      }
      if (event is RepoOnTodoRemoved) {
        return OnTodoRemoved(event.entity);
      }
    });

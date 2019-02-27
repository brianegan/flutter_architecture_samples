library edit;

import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:dartea/dartea.dart';
import 'package:mvu/edit/types.dart';
import 'package:mvu/common/repository_commands.dart' show CmdRepository;
import 'package:mvu/common/router.dart' as router;

part 'state.dart';
part 'view.dart';

Program<EditTodoModel, EditTodoMessage, dynamic> createProgram(
        CmdRepository repo,
        {TodoEntity todo}) =>
    Program(() => init(todo), (msg, model) => update(repo, msg, model), view);

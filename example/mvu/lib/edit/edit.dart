library edit;

import 'package:flutter/material.dart';

import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:dartea/dartea.dart';
import 'package:mvu/edit/types.dart';
import 'package:mvu/common/repository_commands.dart' as repo;
import 'package:mvu/common/router.dart' as router;

part 'state.dart';
part 'view.dart';

Program<TodoEntity, EditTodoModel, EditTodoMessage> createProgram() =>
    new Program(init, update, view);

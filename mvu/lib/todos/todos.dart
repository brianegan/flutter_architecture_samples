library todos;

import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';

import 'package:mvu/common/repository_commands.dart' show CmdRepository;
import 'package:mvu/common/router.dart' as router;
import 'package:todos_app_core/todos_app_core.dart';
import 'package:dartea/dartea.dart';
import 'package:mvu/home/types.dart';
import 'package:mvu/todos/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:mvu/common/extra_actions_menu.dart' as menu;
import 'package:mvu/common/snackbar.dart' as snackbar;

part 'state.dart';
part 'view.dart';

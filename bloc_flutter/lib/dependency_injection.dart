// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

// A poor man's DI. This should be replaced by a proper solution once they
// are more stable.
library dependency_injector;

import 'package:blocs/blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class Injector extends InheritedWidget {
  final TodosInteractor todosInteractor;
  final UserRepository userRepository;

  Injector({
    Key key,
    @required this.todosInteractor,
    @required this.userRepository,
    @required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injector>();

  @override
  bool updateShouldNotify(Injector oldWidget) =>
      todosInteractor != oldWidget.todosInteractor ||
      userRepository != oldWidget.userRepository;
}

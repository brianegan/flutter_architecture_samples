// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:blocs/blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TodosBlocProvider extends InheritedWidget {
  final TodosBloc bloc;

  TodosBlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  static TodosBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TodosBlocProvider)
            as TodosBlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(TodosBlocProvider old) => bloc != old.bloc;
}

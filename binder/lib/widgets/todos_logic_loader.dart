import 'dart:async';

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:flutter/material.dart';

class TodosLogicLoader extends StatefulWidget {
  const TodosLogicLoader({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  _TodosLogicLoaderState createState() => _TodosLogicLoaderState();
}

class _TodosLogicLoaderState extends State<TodosLogicLoader> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.use(todosLogicRef).init());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_sample/stores/todo_store.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

class FilterButton extends StatelessWidget {
  final bool isActive;

  const FilterButton({this.isActive, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<TodoStore>(context);

    return IgnorePointer(
      ignoring: !isActive,
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: Observer(
          builder: (context) {
            return PopupMenuButton<VisibilityFilter>(
              key: ArchSampleKeys.filterButton,
              tooltip: ArchSampleLocalizations.of(context).filterTodos,
              initialValue: store.filter,
              onSelected: (filter) => store.filter = filter,
              itemBuilder: (BuildContext context) => _items(context, store),
              icon: const Icon(Icons.filter_list),
            );
          },
        ),
      ),
    );
  }

  List<PopupMenuItem<VisibilityFilter>> _items(
      BuildContext context, TodoStore store) {
    final activeStyle = Theme.of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);
    final defaultStyle = Theme.of(context).textTheme.body1;

    return [
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.allFilter,
        value: VisibilityFilter.all,
        child: Text(
          ArchSampleLocalizations.of(context).showAll,
          style:
              store.filter == VisibilityFilter.all ? activeStyle : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.activeFilter,
        value: VisibilityFilter.pending,
        child: Text(
          ArchSampleLocalizations.of(context).showActive,
          style: store.filter == VisibilityFilter.pending
              ? activeStyle
              : defaultStyle,
        ),
      ),
      PopupMenuItem<VisibilityFilter>(
        key: ArchSampleKeys.completedFilter,
        value: VisibilityFilter.completed,
        child: Text(
          ArchSampleLocalizations.of(context).showCompleted,
          style: store.filter == VisibilityFilter.completed
              ? activeStyle
              : defaultStyle,
        ),
      ),
    ];
  }
}

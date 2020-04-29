// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../../../service/common/enums.dart';
import '../../../service/todos_state.dart';
import '../../common/enums.dart';

class FilterButton extends StatelessWidget {
  //Accept the activeTabRM defined in the HomePage
  const FilterButton({this.activeTabRM, Key key}) : super(key: key);
  final ReactiveModel<AppTab> activeTabRM;
  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme.of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);
    final button = _Button(
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );

    return StateBuilder(
        //register to activeTabRM
        observe: () => activeTabRM,
        builder: (context, activeTabRM) {
          final _isActive = activeTabRM.value == AppTab.todos;
          return AnimatedOpacity(
            opacity: _isActive ? 1.0 : 0.0,
            duration: Duration(milliseconds: 150),
            child: _isActive ? button : IgnorePointer(child: button),
          );
        });
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.activeStyle,
    @required this.defaultStyle,
  }) : super(key: key);

  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    //This is an example of Local ReactiveModel
    return StateBuilder<VisibilityFilter>(
        //Create and subscribe to a ReactiveModel of type VisibilityFilter
        observe: () => RM.create(VisibilityFilter.all),
        builder: (context, activeFilterRM) {
          return PopupMenuButton<VisibilityFilter>(
            key: ArchSampleKeys.filterButton,
            tooltip: ArchSampleLocalizations.of(context).filterTodos,
            onSelected: (filter) {
              //Compere this onSelected callBack with that of the ExtraActionsButton widget.
              //
              //In ExtraActionsButton, we did not use the setValue.
              //Here we use the setValue (although we can use  activeFilterRM.value = filter ).

              //
              //The reason we use setValue is to minimize the rebuild process.
              //If the use select the same option, the setValue method will not notify observers.
              //and onData will not invoked.
              activeFilterRM.setValue(
                () => filter,
                onData: (_, __) {
                  //get and set the value of the global ReactiveModel TodosStore
                  RM.get<TodosState>().value =
                      RM.get<TodosState>().value.copyWith(activeFilter: filter);
                },
              );
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<VisibilityFilter>>[
              PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.allFilter,
                value: VisibilityFilter.all,
                child: Text(
                  ArchSampleLocalizations.of(context).showAll,
                  style: activeFilterRM.value == VisibilityFilter.all
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.activeFilter,
                value: VisibilityFilter.active,
                child: Text(
                  ArchSampleLocalizations.of(context).showActive,
                  style: activeFilterRM.value == VisibilityFilter.active
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.completedFilter,
                value: VisibilityFilter.completed,
                child: Text(
                  ArchSampleLocalizations.of(context).showCompleted,
                  style: activeFilterRM.value == VisibilityFilter.completed
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
            ],
            icon: Icon(Icons.filter_list),
          );
        });
  }
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/const/TodoDataParams.dart';
import 'package:wire_flutter_todo/const/TodoFilterValues.dart';
import 'package:wire_flutter_todo/const/TodoViewSignal.dart';
import 'package:wire_flutter_todo/localization.dart';
import 'package:wire_flutter_todo/models.dart';
import 'package:wire_flutter_todo/widgets/buttons/extra_actions_button.dart';
import 'package:wire_flutter_todo/widgets/buttons/filter_button.dart';
import 'package:wire_flutter_todo/widgets/stats_counter.dart';
import 'package:wire_flutter_todo/widgets/list/todo_list_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  AppTab activeTab = AppTab.todos;

  void _updateTab(AppTab tab) {
    setState(() {
      activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(VanillaLocalizations.of(context).appTitle),
        actions: [
          FilterButton(
            isActive: activeTab == AppTab.todos,
            activeFilter: TodoFilterValue.ALL,
            onSelected: (filter) => Wire.send(TodoViewSignal.FILTER, filter),
          ),
          WireDataBuilder<int>(
            param: TodoDataParams.COUNT,
            builder: (context, not_completed_count) {
              var allTodoCount = Wire.data(TodoDataParams.LIST).value.length;
              var allCompleted = not_completed_count == 0 && allTodoCount > 0;
              var hasCompletedTodos = (allTodoCount - not_completed_count) > 0;
              return ExtraActionsButton(
                allComplete: allCompleted,
                hasCompletedTodos: hasCompletedTodos,
                onSelected: (action) {
                  if (action == ExtraAction.toggleAllComplete) {
                    Wire.send(TodoViewSignal.COMPLETE_ALL, !allCompleted);
                  } else if (action == ExtraAction.clearCompleted) {
                    Wire.send(TodoViewSignal.CLEAR_COMPLETED);
                  }
                },
            );},
          )
        ],
      ),
      body: activeTab == AppTab.todos
          ? TodoList()
          : StatsCounter(),

      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () => Navigator.pushNamed(context, ArchSampleRoutes.addTodo),
        child: Icon(Icons.add),
        tooltip: ArchSampleLocalizations.of(context).addTodo,
      ),
      bottomNavigationBar: BottomNavigationWidget(activeTab)
    );
  }

  Widget BottomNavigationWidget(activeTab) => BottomNavigationBar(
    key: ArchSampleKeys.tabs,
    currentIndex: AppTab.values.indexOf(activeTab),
    onTap: (index) { _updateTab(AppTab.values[index]); },
    items: AppTab.values.map((tab) {
      return BottomNavigationBarItem(
        icon: Icon(
          tab == AppTab.todos ? Icons.list : Icons.show_chart,
          key: tab == AppTab.stats
            ? ArchSampleKeys.statsTab
            : ArchSampleKeys.todoTab,
        ),
        title: Text(
          tab == AppTab.stats
            ? ArchSampleLocalizations.of(context).stats
            : ArchSampleLocalizations.of(context).todos,
        ),
      );
    }).toList(),
  );
}

// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/localization.dart';
import 'package:binder_sample/models.dart';
import 'package:binder_sample/widgets/extra_actions_button.dart';
import 'package:binder_sample/widgets/filter_button.dart';
import 'package:binder_sample/widgets/stats_counter.dart';
import 'package:binder_sample/widgets/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

final activeTabRef = StateRef(AppTab.todos);

final tabSelectorLogicRef = LogicRef((scope) => TabSelectorLogic(scope));

class TabSelectorLogic with Logic {
  const TabSelectorLogic(this.scope);

  @override
  final Scope scope;

  AppTab get activeTab => read(activeTabRef);
  set activeTab(AppTab value) => write(activeTabRef, value);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  Widget build(BuildContext context) {
    final activeTab = context.watch(activeTabRef);

    return Scaffold(
      appBar: AppBar(
        title: Text(BinderLocalizations.of(context).appTitle),
        actions: [
          FilterButton(isActive: activeTab == AppTab.todos),
          const ExtraActionsButton()
        ],
      ),
      body: activeTab == AppTab.todos ? const TodoList() : const StatsCounter(),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () {
          Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
        },
        child: Icon(Icons.add),
        tooltip: ArchSampleLocalizations.of(context).addTodo,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: ArchSampleKeys.tabs,
        currentIndex: AppTab.values.indexOf(activeTab),
        onTap: (index) {
          context.use(tabSelectorLogicRef).activeTab = AppTab.values[index];
        },
        items: AppTab.values.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(
              tab == AppTab.todos ? Icons.list : Icons.show_chart,
              key: tab == AppTab.stats
                  ? ArchSampleKeys.statsTab
                  : ArchSampleKeys.todoTab,
            ),
            label: tab == AppTab.stats
                ? ArchSampleLocalizations.of(context).stats
                : ArchSampleLocalizations.of(context).todos,
          );
        }).toList(),
      ),
    );
  }
}

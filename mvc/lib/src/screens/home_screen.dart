// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart'
    show ArchSampleKeys, ArchSampleLocalizations, ArchSampleRoutes;

import 'package:mvc/src/models.dart' show AppTab;
import 'package:mvc/src/widgets/extra_actions_button.dart'
    show ExtraActionsButton;
import 'package:mvc/src/widgets/filter_button.dart' show FilterButton;
import 'package:mvc/src/widgets/stats_counter.dart' show StatsCounter;
import 'package:mvc/src/widgets/todo_list.dart' show TodoList;

import 'package:mvc/src/Controller.dart' show Con;

class HomeScreen extends StatefulWidget {
  @protected
  @override
  State<HomeScreen> createState() => HomeView();
}

class HomeView extends State<HomeScreen> {
  AppTab _activeTab = AppTab.todos;

  final Con _con = Con.con;

  @protected
  @override
  void initState() {
    super.initState();

    /// Calls the Controller when this one-time 'init' event occurs.
    /// Not revealing the 'business logic' that then fires inside.
    _con.init();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// The View need not know nor care what the title is. The Controller does.
        title: Text(_con.title),
        actions: [
          FilterButton(isActive: _activeTab == AppTab.todos),
          ExtraActionsButton()
        ],
      ),
      body: _activeTab == AppTab.todos ? TodoList() : StatsCounter(),
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
        currentIndex: AppTab.values.indexOf(_activeTab),
        onTap: (index) {
          setState(() {
            _activeTab = AppTab.values[index];
          });
        },
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
      ),
    );
  }
}

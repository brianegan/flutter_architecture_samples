// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rvms_model_sample/display_todos/_model/typedefs.dart';
import 'package:rvms_model_sample/display_todos/widgets/extra_actions_button.dart';
import 'package:rvms_model_sample/display_todos/widgets/filter_button.dart';
import 'package:rvms_model_sample/display_todos/widgets/stats_counter.dart';
import 'package:rvms_model_sample/display_todos/widgets/todo_list.dart';
import 'package:rvms_model_sample/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  AppTab _activeTab = AppTab.todos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: GetIt.I.allReady(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(RvmsLocalizations.of(context).appTitle),
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
                  _updateTab(AppTab.values[index]);
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
        });
  }

  _updateTab(AppTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }
}

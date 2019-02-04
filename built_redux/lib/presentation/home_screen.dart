// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/containers/action_selector.dart';
import 'package:built_redux_sample/containers/active_tab.dart';
import 'package:built_redux_sample/containers/filter_selector.dart';
import 'package:built_redux_sample/containers/filtered_todos.dart';
import 'package:built_redux_sample/containers/stats.dart';
import 'package:built_redux_sample/containers/tab_selector.dart';
import 'package:built_redux_sample/localization.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/presentation/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(BuiltReduxLocalizations.of(context).appTitle),
            actions: [
              FilterSelector(
                builder: (context, vm) {
                  return FilterButton(
                    visible: activeTab == AppTab.todos,
                    activeFilter: vm.activeFilter,
                    onSelected: vm.onFilterSelected,
                  );
                },
              ),
              ExtraActionSelector()
            ],
          ),
          body: activeTab == AppTab.todos ? FilteredTodos() : Stats(),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: TabSelector(),
        );
      },
    );
  }
}

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
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(BuiltReduxLocalizations.of(context).appTitle),
            actions: [
              new FilterSelector(
                builder: (context, vm) {
                  return new FilterButton(
                    visible: activeTab == AppTab.todos,
                    activeFilter: vm.activeFilter,
                    onSelected: vm.onFilterSelected,
                  );
                },
              ),
              new ExtraActionSelector()
            ],
          ),
          body: activeTab == AppTab.todos ? new FilteredTodos() : new Stats(),
          floatingActionButton: new FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: new Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: new TabSelector(),
        );
      },
    );
  }
}

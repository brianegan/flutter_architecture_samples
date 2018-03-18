// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:fire_redux_sample/containers/extra_actions_container.dart';
import 'package:fire_redux_sample/containers/filter_selector.dart';
import 'package:fire_redux_sample/containers/active_tab.dart';
import 'package:fire_redux_sample/containers/filtered_todos.dart';
import 'package:fire_redux_sample/containers/stats.dart';
import 'package:fire_redux_sample/containers/tab_selector.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:fire_redux_sample/localization.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  Widget build(BuildContext context) {
    return new ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(FirestoreReduxLocalizations.of(context).appTitle),
            actions: [
              new FilterSelector(visible: activeTab == AppTab.todos),
              new ExtraActionsContainer(),
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

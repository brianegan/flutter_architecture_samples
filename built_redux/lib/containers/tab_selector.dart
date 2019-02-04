// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart';

typedef OnTabsSelected = void Function(int);

class TabSelector extends StoreConnector<AppState, AppActions, AppTab> {
  TabSelector({Key key}) : super(key: key);

  @override
  AppTab connect(AppState state) => state.activeTab;

  @override
  Widget build(BuildContext context, AppTab activeTab, AppActions action) {
    return BottomNavigationBar(
      key: ArchSampleKeys.tabs,
      currentIndex: AppTab.toIndex(activeTab),
      onTap: (index) {
        action.updateTabAction(AppTab.fromIndex(index));
      },
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.todos ? Icons.list : Icons.show_chart,
            key: tab == AppTab.stats
                ? ArchSampleKeys.statsTab
                : ArchSampleKeys.todoTab,
          ),
          title: Text(tab == AppTab.stats
              ? ArchSampleLocalizations.of(context).stats
              : ArchSampleLocalizations.of(context).todos),
        );
      }).toList(),
    );
  }
}

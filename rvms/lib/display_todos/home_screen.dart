// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:functional_listener/functional_listener.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_model/typedefs.dart';
import 'package:rvms_model_sample/display_todos/widgets/extra_actions_button.dart';
import 'package:rvms_model_sample/display_todos/widgets/filter_button.dart';
import 'package:rvms_model_sample/display_todos/widgets/stats_counter.dart';
import 'package:rvms_model_sample/display_todos/widgets/todo_list.dart';
import 'package:rvms_model_sample/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with GetItStateMixin {
  AppTab _activeTab = AppTab.todos;

  @override
  Widget build(BuildContext context) {
    /// We use GetIt's start-up synchronization support here
    if (!allReady()) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      /// Show an Error dialog whenever the TodoManager reports an error
      registerHandler((TodoManager manager) => manager.errors,
          (context, message, _) => showErrorDlg(context, message));

      /// if data uploading takes longer than 500ms show a waiting spinner
      registerHandler(
          (TodoManager manager) => manager.upLoadCommand.isExecuting
              .debounce(Duration(milliseconds: 500)),
          (context, busy, __) => showSpinner(context, busy));

      ///alterrnative snackbar
      // registerHandler(
      //     (TodoManager manager) => manager.upLoadCommand,
      //     (context, snackText, _) => Scaffold.of(context).showSnackBar(
      //           SnackBar(
      //             content: Text(snackText),
      //             duration: Duration(milliseconds: 800),
      //           ),
      //         ));

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
  }

  _updateTab(AppTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  void showErrorDlg(BuildContext context, message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('There was a problem saving your data'),
              content: Text(message),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  OverlayEntry spinner;

  showSpinner(BuildContext context, busy) {
    if (busy && spinner == null) {
      spinner = OverlayEntry(
        builder: (context) => Center(
          child: CircularProgressIndicator(
            key: Key('busySpinner'),
          ),
        ),
      );
      Overlay.of(context).insert(spinner);
    } else {
      spinner?.remove();
      spinner = null;
    }
  }
}

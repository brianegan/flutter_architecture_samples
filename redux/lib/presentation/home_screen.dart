import 'package:flutter/material.dart';
import 'package:redux_sample/containers/active_tab.dart';
import 'package:redux_sample/containers/extra_actions_container.dart';
import 'package:redux_sample/containers/filter_selector.dart';
import 'package:redux_sample/containers/filtered_todos.dart';
import 'package:redux_sample/containers/stats.dart';
import 'package:redux_sample/containers/tab_selector.dart';
import 'package:redux_sample/localization.dart';
import 'package:redux_sample/models/models.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;

  const HomeScreen({
    super.key = ArchSampleKeys.homeScreen,
    required this.onInit,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(ReduxLocalizations.of(context).appTitle),
            actions: [
              FilterSelector(visible: activeTab == AppTab.todos),
              ExtraActionsContainer(),
            ],
          ),
          body: activeTab == AppTab.todos ? FilteredTodos() : Stats(),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            tooltip: ArchSampleLocalizations.of(context).addTodo,
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: TabSelector(),
        );
      },
    );
  }
}

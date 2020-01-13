import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../../../localization.dart';
import '../../../service/todos_service.dart';
import '../../common/enums.dart';
import 'extra_actions_button.dart';
import 'filter_button.dart';
import 'stats_counter.dart';
import 'todo_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key ?? ArchSampleKeys.homeScreen);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Here we use a StatefulWidget to store the _activeTab state which is private to this class

  AppTab _activeTab = AppTab.todos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StatesRebuilderLocalizations.of(context).appTitle),
        actions: [
          FilterButton(isActive: _activeTab == AppTab.todos),
          ExtraActionsButton(),
        ],
      ),
      body: StateBuilder<TodosService>(
        models: [Injector.getAsReactive<TodosService>()],
        initState: (_, todosServiceRM) {
          //update state and notify observer
          return todosServiceRM.setState((s) => s.loadTodos());
        },
        builder: (_, todosServiceRM) {
          return _activeTab == AppTab.todos ? TodoList() : StatsCounter();
        },
      ),
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
          //mutate the state of the private field _activeTab and use Flutter setState because
          setState(() => _activeTab = AppTab.values[index]);
        },
        items: AppTab.values.map(
          (tab) {
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
          },
        ).toList(),
      ),
    );
  }
}

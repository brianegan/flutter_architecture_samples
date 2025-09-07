import 'package:flutter/material.dart';
import 'package:scoped_model_sample/localization.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/widgets/extra_actions_button.dart';
import 'package:scoped_model_sample/widgets/filter_button.dart';
import 'package:scoped_model_sample/widgets/stats_counter.dart';
import 'package:scoped_model_sample/widgets/todo_list.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  AppTab _activeTab = AppTab.todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ScopedModelLocalizations.of(context).appTitle),
        actions: [
          FilterButton(isActive: _activeTab == AppTab.todos),
          ExtraActionsButton(),
        ],
      ),
      body: _activeTab == AppTab.todos ? TodoList() : StatsCounter(),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () {
          Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
        },
        tooltip: ArchSampleLocalizations.of(context).addTodo,
        child: Icon(Icons.add),
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

  void _updateTab(AppTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }
}

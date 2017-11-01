import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:redux_sample/containers/action_selector.dart';
import 'package:redux_sample/containers/filter_selector.dart';
import 'package:redux_sample/containers/active_tab.dart';
import 'package:redux_sample/containers/filtered_todos.dart';
import 'package:redux_sample/containers/stats.dart';
import 'package:redux_sample/containers/tab_selector.dart';
import 'package:redux_sample/models.dart';
import 'package:redux_sample/localization.dart';
import 'package:redux_sample/widgets/extra_actions_button.dart';
import 'package:redux_sample/widgets/filter_button.dart';
import 'package:redux_sample/widgets/stats_counter.dart';
import 'package:redux_sample/widgets/todo_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(ReduxLocalizations.of(context).appTitle),
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
              new ActionSelector(
                builder: (context, vm) {
                  return new ExtraActionsButton(
                    allComplete: vm.allComplete,
                    onSelected: vm.onActionSelected,
                  );
                },
              )
            ],
          ),
          body: activeTab == AppTab.todos
              ? new FilteredTodos(
                  builder: (context, vm) {
                    return new TodoList(
                      todos: vm.todos,
                      onCheckboxChanged: vm.onCheckboxChanged,
                      onRemove: vm.onRemove,
                      onUndoRemove: vm.onUndoRemove,
                    );
                  },
                )
              : new Stats(
                  builder: (context, vm) {
                    return new StatsCounter(
                      numActive: vm.numActive,
                      numCompleted: vm.numCompleted,
                    );
                  },
                ),
          floatingActionButton: new FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: new Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: new TabSelector(
            builder: (context, vm) {
              return new BottomNavigationBar(
                key: ArchSampleKeys.tabs,
                currentIndex: AppTab.values.indexOf(activeTab),
                onTap: (index) {
                  vm.onTabSelected(AppTab.values[index]);
                },
                items: AppTab.values.map((tab) {
                  return new BottomNavigationBarItem(
                    icon: new Icon(
                        tab == AppTab.todos ? Icons.list : Icons.show_chart),
                    title: new Text(tab == AppTab.stats
                        ? ArchSampleLocalizations.of(context).stats
                        : ArchSampleLocalizations.of(context).todos),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}

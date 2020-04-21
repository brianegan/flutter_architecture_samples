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

// RM.printActiveRM = true;
class HomeScreen extends StatelessWidget {
  //create a local ReactiveeModel to deal with the state of the tabs.
  final _activeTabRMKey = RMKey(AppTab.todos);
  @override
  Widget build(BuildContext context) {
    print('rebuild HomeScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text(StatesRebuilderLocalizations.of(context).appTitle),
        actions: [
          FilterButton(activeTabRM: _activeTabRMKey),
          ExtraActionsButton(),
        ],
      ),
      body: WhenRebuilderOr<AppTab>(
        observeMany: [
          () => RM.getFuture<TodosService, void>((t) => t.loadTodos()),
          () => _activeTabRMKey,
        ],
        onWaiting: () {
          return Center(
            child: CircularProgressIndicator(
              key: ArchSampleKeys.todosLoading,
            ),
          );
        },
        builder: (context, _activeTabRM) {
          return _activeTabRM.value == AppTab.todos
              ? TodoList()
              : StatsCounter();
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
      bottomNavigationBar: StateBuilder<AppTab>(
          observe: () => RM.create(AppTab.todos),
          rmKey: _activeTabRMKey,
          builder: (context, _activeTabRM) {
            return BottomNavigationBar(
              key: ArchSampleKeys.tabs,
              currentIndex: AppTab.values.indexOf(_activeTabRM.value),
              onTap: (index) {
                //mutate the value of the private field _activeTab,
                //observing widget will be notified to rebuild
                _activeTabRM.value = AppTab.values[index];
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
            );
          }),
    );
  }
}

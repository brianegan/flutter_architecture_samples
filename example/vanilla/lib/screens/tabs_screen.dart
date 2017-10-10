import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvc/flutter_mvc.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/localization.dart';
import 'package:vanilla/widgets/extra_actions_button.dart';
import 'package:vanilla/widgets/filter_button.dart';
import 'package:vanilla/widgets/stats_counter.dart';
import 'package:vanilla/widgets/todo_list.dart';
import 'package:vanilla/widgets/typedefs.dart';

class TabsScreen extends StatelessWidget {
  final AppState appState;
  final TabUpdater updateTab;
  final VisibilityFilterUpdater updateFiler;
  final TodoAdder addTodo;
  final TodoRemover removeTodo;
  final TodoUpdater updateTodo;
  final Function toggleAll;
  final Function clearCompleted;

  TabsScreen({
    @required this.appState,
    @required this.updateTab,
    @required this.updateFiler,
    @required this.addTodo,
    @required this.removeTodo,
    @required this.updateTodo,
    @required this.toggleAll,
    @required this.clearCompleted,
    Key key,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(VanillaLocalizations.of(context).appTitle),
        actions: [
          new FilterButton(
            isActive: appState.activeTab == AppTab.todos,
            activeFilter: appState.activeFilter,
            onSelected: updateFiler,
          ),
          new ExtraActionsButton(
            allComplete: appState.allComplete,
            hasCompletedTodos: appState.hasCompletedTodos,
            onSelected: (action) {
              if (action == ExtraAction.toggleAllComplete) {
                toggleAll();
              } else if (action == ExtraAction.clearCompleted) {
                clearCompleted();
              }
            },
          )
        ],
      ),
      body: appState.activeTab == AppTab.todos
          ? new TodoList(
              filteredTodos: appState.filteredTodos,
              loading: appState.isLoading,
              removeTodo: removeTodo,
              addTodo: addTodo,
              updateTodo: updateTodo,
            )
          : new StatsCounter(
              numActive: appState.numActive,
              numCompleted: appState.numCompleted,
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, FlutterMvcRoutes.addTodo);
        },
        child: new Icon(Icons.add),
        tooltip: ArchitectureLocalizations.of(context).addTodo,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: AppTab.values.indexOf(appState.activeTab),
        onTap: (index) {
          updateTab(AppTab.values[index]);
        },
        items: AppTab.values.map((tab) {
          return new BottomNavigationBarItem(
            icon: new Icon(tab == AppTab.todos ? Icons.list : Icons.show_chart),
            title: new Text(tab == AppTab.stats
                ? ArchitectureLocalizations.of(context).stats
                : ArchitectureLocalizations.of(context).todos),
          );
        }).toList(),
      ),
    );
  }
}

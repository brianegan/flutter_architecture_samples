import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/actions/clear_completed.dart';
import 'package:redurx_sample/actions/toggle_all_complete.dart';
import 'package:redurx_sample/actions/update_filter.dart';
import 'package:redurx_sample/actions/update_tab.dart';
import 'package:redurx_sample/localizations.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/app_tab.dart';
import 'package:redurx_sample/models/extra_actions.dart';
import 'package:redurx_sample/models/visibility_filter.dart';
import 'package:redurx_sample/widgets/extra_actions_button.dart';
import 'package:redurx_sample/widgets/filter_button.dart';
import 'package:redurx_sample/widgets/stats_counter.dart';
import 'package:redurx_sample/widgets/todo_list.dart';
import 'package:tuple/tuple.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ReduRxLocalizations.of(context).appTitle),
        actions: [
          Connect<AppState, Tuple2<AppTab, VisibilityFilter>>(
            convert: (state) => Tuple2(state.activeTab, state.activeFilter),
            where: (prev, next) => next != prev,
            builder: (props) {
              return FilterButton(
                isActive: props.item1 == AppTab.todos,
                activeFilter: props.item2,
                onSelected: (filter) {
                  Provider.dispatch<AppState>(context, UpdateFilter(filter));
                },
              );
            },
          ),
          Connect<AppState, bool>(
            convert: (state) => state.allCompleteSelector,
            where: (prev, next) => next != prev,
            builder: (allComplete) {
              return ExtraActionsButton(
                allComplete: allComplete,
                onSelected: (action) {
                  if (action == ExtraAction.toggleAllComplete) {
                    Provider.dispatch<AppState>(context, ToggleAllComplete());
                  } else if (action == ExtraAction.clearCompleted) {
                    Provider.dispatch<AppState>(context, ClearCompleted());
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Connect<AppState, AppTab>(
        convert: (state) => state.activeTab,
        where: (prev, next) => next != prev,
        builder: (activeTab) {
          return activeTab == AppTab.todos ? TodoList() : StatsCounter();
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
      bottomNavigationBar: Connect<AppState, AppTab>(
        convert: (state) => state.activeTab,
        where: (prev, next) => next != prev,
        builder: (activeTab) {
          return BottomNavigationBar(
            key: ArchSampleKeys.tabs,
            currentIndex: AppTab.toIndex(activeTab),
            onTap: (index) {
              Provider.dispatch<AppState>(
                  context, UpdateTab(AppTab.fromIndex(index)));
            },
            items: AppTab.values.map((tab) {
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
            }).toList(),
          );
        },
      ),
    );
  }
}

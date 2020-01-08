import 'package:flutter/material.dart';

import 'package:todos_app_core/todos_app_core.dart';

import 'package:frideos/frideos.dart';

import 'package:frideos_library/app_state.dart';
import 'package:frideos_library/localization.dart';
import 'package:frideos_library/blocs/todos_bloc.dart';
import 'package:frideos_library/models/models.dart';
import 'package:frideos_library/widgets/extra_actions_button.dart';
import 'package:frideos_library/widgets/filter_button.dart';
import 'package:frideos_library/widgets/todo_list.dart';
import 'package:frideos_library/widgets/stats_counter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateProvider.of<AppState>(context).todosBloc;
    final tabController = AppStateProvider.of<AppState>(context).tabController;

    return ValueBuilder<AppTab>(
      streamed: tabController,
      builder: (context, activeTabSnapshot) => Scaffold(
        appBar: AppBar(
          title: Text(FrideosLocalizations.of(context).appTitle),
          actions: _buildActions(
            bloc,
            activeTabSnapshot,
          ),
        ),
        body: activeTabSnapshot.data == AppTab.todos
            ? TodoList()
            : StatsCounter(),
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
          currentIndex: AppTab.values.indexOf(activeTabSnapshot.data),
          onTap: (index) {
            tabController.value = AppTab.values[index];
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
        ),
      ),
    );
  }

  List<Widget> _buildActions(
      TodosBloc bloc, AsyncSnapshot<AppTab> activeTabSnapshot) {
    return [
      ValueBuilder<VisibilityFilter>(
        streamed: bloc.activeFilter,
        builder: (context, snapshot) {
          return FilterButton(
            isActive: activeTabSnapshot.data == AppTab.todos,
            activeFilter: snapshot.data ?? VisibilityFilter.all,
            onSelected: bloc.activeFilter.inStream,
          );
        },
      ),
      ValueBuilder<bool>(
        streamed: bloc.allComplete,
        builder: (context, snapshot) {
          return ExtraActionsButton(
            allComplete: snapshot?.data ?? false,
          );
        },
      ),
    ];
  }
}

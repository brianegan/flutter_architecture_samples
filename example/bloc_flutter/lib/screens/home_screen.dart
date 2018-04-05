// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:bloc_flutter_sample/localization.dart';
import 'package:bloc_flutter_sample/models.dart';
import 'package:bloc_flutter_sample/todos_bloc_provider.dart';
import 'package:bloc_flutter_sample/widgets/extra_actions_button.dart';
import 'package:bloc_flutter_sample/widgets/filter_button.dart';
import 'package:bloc_flutter_sample/widgets/stats_counter.dart';
import 'package:bloc_flutter_sample/widgets/todo_list.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  StreamController<AppTab> tabController;

  @override
  void initState() {
    super.initState();

    tabController = new StreamController<AppTab>();
  }

  @override
  void dispose() {
    tabController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = TodosBlocProvider.of(context);

    return new StreamBuilder<AppTab>(
      initialData: AppTab.todos,
      stream: tabController.stream,
      builder: (context, activeTabSnapshot) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(BlocLocalizations.of(context).appTitle),
            actions: [
              new StreamBuilder<VisibilityFilter>(
                stream: bloc.activeFilter,
                builder: (context, snapshot) => new FilterButton(
                      isActive: activeTabSnapshot.data == AppTab.todos,
                      activeFilter: snapshot.data ?? VisibilityFilter.all,
                      onSelected: bloc.updateFilter.add,
                    ),
              ),
              new StreamBuilder<ExtraActionsButtonViewModel>(
                stream: Observable.combineLatest2(
                  bloc.allComplete,
                  bloc.hasCompletedTodos,
                  (allComplete, hasCompletedTodos) =>
                      new ExtraActionsButtonViewModel(
                        allComplete,
                        hasCompletedTodos,
                      ),
                ),
                builder: (context, snapshot) {
                  return new ExtraActionsButton(
                    allComplete: snapshot.data?.allComplete ?? false,
                    hasCompletedTodos:
                        snapshot.data?.hasCompletedTodos ?? false,
                    onSelected: (action) {
                      if (action == ExtraAction.toggleAllComplete) {
                        bloc.toggleAll.add(null);
                      } else if (action == ExtraAction.clearCompleted) {
                        bloc.clearCompleted.add(null);
                      }
                    },
                  );
                },
              )
            ],
          ),
          body: activeTabSnapshot.data == AppTab.todos
              ? new TodoList()
              : new StatsCounter(),
          floatingActionButton: new FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: new Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: new BottomNavigationBar(
            key: ArchSampleKeys.tabs,
            currentIndex: AppTab.values.indexOf(activeTabSnapshot.data),
            onTap: (index) {
              tabController.add(AppTab.values[index]);
            },
            items: AppTab.values.map((tab) {
              return new BottomNavigationBarItem(
                icon: new Icon(
                  tab == AppTab.todos ? Icons.list : Icons.show_chart,
                  key: tab == AppTab.stats
                      ? ArchSampleKeys.statsTab
                      : ArchSampleKeys.todoTab,
                ),
                title: new Text(
                  tab == AppTab.stats
                      ? ArchSampleLocalizations.of(context).stats
                      : ArchSampleLocalizations.of(context).todos,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

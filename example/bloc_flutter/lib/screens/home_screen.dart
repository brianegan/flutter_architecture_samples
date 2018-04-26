// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:bloc_flutter_sample/dependency_injection.dart';
import 'package:bloc_flutter_sample/localization.dart';
import 'package:bloc_flutter_sample/widgets/extra_actions_button.dart';
import 'package:bloc_flutter_sample/widgets/filter_button.dart';
import 'package:bloc_flutter_sample/widgets/loading.dart';
import 'package:bloc_flutter_sample/widgets/stats_counter.dart';
import 'package:bloc_flutter_sample/widgets/todo_list.dart';
import 'package:bloc_flutter_sample/widgets/todos_bloc_provider.dart';
import 'package:blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todos_repository/todos_repository.dart';

enum AppTab { todos, stats }

class HomeScreen extends StatefulWidget {
  final UserRepository repository;

  HomeScreen({@required this.repository})
      : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  UserBloc usersBloc;
  StreamController<AppTab> tabController;

  @override
  void initState() {
    super.initState();

    usersBloc = UserBloc(widget.repository);
    tabController = StreamController<AppTab>();
  }

  @override
  void dispose() {
    tabController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todosBloc = TodosBlocProvider.of(context);

    return StreamBuilder<UserEntity>(
      stream: usersBloc.login(),
      builder: (context, userSnapshot) {
        return StreamBuilder<AppTab>(
          initialData: AppTab.todos,
          stream: tabController.stream,
          builder: (context, activeTabSnapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(BlocLocalizations.of(context).appTitle),
                actions: _buildActions(
                  todosBloc,
                  activeTabSnapshot,
                  userSnapshot.hasData,
                ),
              ),
              body: userSnapshot.hasData
                  ? activeTabSnapshot.data == AppTab.todos
                      ? TodoList()
                      : StatsCounter(
                          buildBloc: () =>
                              StatsBloc(Injector.of(context).todosInteractor),
                        )
                  : LoadingSpinner(
                      key: ArchSampleKeys.todosLoading,
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
                currentIndex: AppTab.values.indexOf(activeTabSnapshot.data),
                onTap: (index) {
                  tabController.add(AppTab.values[index]);
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
            );
          },
        );
      },
    );
  }

  List<Widget> _buildActions(
    TodosListBloc todosBloc,
    AsyncSnapshot<AppTab> activeTabSnapshot,
    bool hasData,
  ) {
    if (!hasData) return [];

    return [
      StreamBuilder<VisibilityFilter>(
        stream: todosBloc.activeFilter,
        builder: (context, snapshot) {
          return FilterButton(
            isActive: activeTabSnapshot.data == AppTab.todos,
            activeFilter: snapshot.data ?? VisibilityFilter.all,
            onSelected: todosBloc.updateFilter.add,
          );
        },
      ),
      StreamBuilder<ExtraActionsButtonViewModel>(
        stream: Observable.combineLatest2(
          todosBloc.allComplete,
          todosBloc.hasCompletedTodos,
          (allComplete, hasCompletedTodos) {
            return ExtraActionsButtonViewModel(
              allComplete,
              hasCompletedTodos,
            );
          },
        ),
        builder: (context, snapshot) {
          return ExtraActionsButton(
            allComplete: snapshot.data?.allComplete ?? false,
            hasCompletedTodos: snapshot.data?.hasCompletedTodos ?? false,
            onSelected: (action) {
              if (action == ExtraAction.toggleAllComplete) {
                todosBloc.toggleAll.add(null);
              } else if (action == ExtraAction.clearCompleted) {
                todosBloc.clearCompleted.add(null);
              }
            },
          );
        },
      )
    ];
  }
}

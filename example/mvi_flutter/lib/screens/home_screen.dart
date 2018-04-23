// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:meta/meta.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/localization.dart';
import 'package:mvi_flutter_sample/widgets/extra_actions_button.dart';
import 'package:mvi_flutter_sample/widgets/filter_button.dart';
import 'package:mvi_flutter_sample/widgets/loading.dart';
import 'package:mvi_flutter_sample/widgets/stats_counter.dart';
import 'package:mvi_flutter_sample/widgets/todo_list.dart';

enum AppTab { todos, stats }

class HomeScreen extends StatefulWidget {
  final TodosInteractor todosInteractor;
  final UserInteractor userInteractor;

  HomeScreen({@required this.userInteractor, @required this.todosInteractor})
      : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TodosListView {
  AppTab activeTab = AppTab.todos;
  TodosListPresenter presenter;

  @override
  void initState() {
    presenter = new TodosListPresenter(
      view: this,
      todosInteractor: widget.todosInteractor,
      userInteractor: widget.userInteractor,
    )..setUp();

    super.initState();
  }

  @override
  void dispose() {
    tearDown();
    presenter.tearDown();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<TodosListModel>(
      stream: presenter,
      initialData: presenter.latest,
      builder: (context, modelSnapshot) => new Scaffold(
            appBar: new AppBar(
              title: new Text(BlocLocalizations.of(context).appTitle),
              actions: [
                new FilterButton(
                  isActive: activeTab == AppTab.todos,
                  activeFilter:
                      modelSnapshot.data?.activeFilter ?? VisibilityFilter.all,
                  onSelected: updateFilter.add,
                ),
                new ExtraActionsButton(
                  allComplete: modelSnapshot.data?.allComplete ?? false,
                  hasCompletedTodos:
                      modelSnapshot.data?.hasCompletedTodos ?? false,
                  onSelected: (action) {
                    if (action == ExtraAction.toggleAllComplete) {
                      toggleAll.add(null);
                    } else if (action == ExtraAction.clearCompleted) {
                      clearCompleted.add(null);
                    }
                  },
                ),
              ],
            ),
            body: modelSnapshot.data.loading
                ? new LoadingSpinner(
                    key: ArchSampleKeys.todosLoading,
                  )
                : activeTab == AppTab.todos
                    ? new TodoList(
                        loading: modelSnapshot.data.loading,
                        addTodo: addTodo.add,
                        updateTodo: updateTodo.add,
                        deleteTodo: deleteTodo.add,
                        todos: modelSnapshot.data?.visibleTodos ?? [],
                      )
                    : new StatsCounter(
                        interactor: Injector.of(context).todosInteractor,
                      ),
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
              currentIndex: AppTab.values.indexOf(activeTab),
              onTap: (index) {
                setState(() {
                  activeTab = AppTab.values[index];
                });
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
          ),
    );
  }
}

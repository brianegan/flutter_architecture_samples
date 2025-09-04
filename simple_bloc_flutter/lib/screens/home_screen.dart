import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_bloc_flutter_sample/dependency_injection.dart';
import 'package:simple_bloc_flutter_sample/localization.dart';
import 'package:simple_bloc_flutter_sample/widgets/extra_actions_button.dart';
import 'package:simple_bloc_flutter_sample/widgets/filter_button.dart';
import 'package:simple_bloc_flutter_sample/widgets/loading.dart';
import 'package:simple_bloc_flutter_sample/widgets/stats_counter.dart';
import 'package:simple_bloc_flutter_sample/widgets/todo_list.dart';
import 'package:simple_bloc_flutter_sample/widgets/todos_bloc_provider.dart';
import 'package:simple_blocs/simple_blocs.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

enum AppTab { todos, stats }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  late UserBloc usersBloc;
  late StreamController<AppTab> tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    usersBloc = UserBloc(Injector.of(context).userRepository);
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
                  : LoadingSpinner(key: ArchSampleKeys.todosLoading),
              floatingActionButton: FloatingActionButton(
                key: ArchSampleKeys.addTodoFab,
                onPressed: () {
                  Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
                },
                tooltip: ArchSampleLocalizations.of(context).addTodo,
                child: const Icon(Icons.add),
              ),
              bottomNavigationBar: BottomNavigationBar(
                key: ArchSampleKeys.tabs,
                currentIndex: AppTab.values.indexOf(activeTabSnapshot.data!),
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
                    label: tab == AppTab.stats
                        ? ArchSampleLocalizations.of(context).stats
                        : ArchSampleLocalizations.of(context).todos,
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
            onSelected: todosBloc.updateFilter,
          );
        },
      ),
      StreamBuilder<ExtraActionsButtonViewModel>(
        stream: Rx.combineLatest2(
          todosBloc.allComplete,
          todosBloc.hasCompletedTodos,
          (allComplete, hasCompletedTodos) {
            return ExtraActionsButtonViewModel(allComplete, hasCompletedTodos);
          },
        ),
        builder: (context, snapshot) {
          return ExtraActionsButton(
            allComplete: snapshot.data?.allComplete ?? false,
            hasCompletedTodos: snapshot.data?.hasCompletedTodos ?? false,
            onSelected: (action) {
              if (action == ExtraAction.toggleAllComplete) {
                todosBloc.toggleAll();
              } else if (action == ExtraAction.clearCompleted) {
                todosBloc.clearCompleted();
              }
            },
          );
        },
      ),
    ];
  }
}

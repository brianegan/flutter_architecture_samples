import 'package:flutter/material.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/dependency_injection.dart';
import 'package:mvi_flutter_sample/localization.dart';
import 'package:mvi_flutter_sample/widgets/extra_actions_button.dart';
import 'package:mvi_flutter_sample/widgets/filter_button.dart';
import 'package:mvi_flutter_sample/widgets/loading.dart';
import 'package:mvi_flutter_sample/widgets/stats_counter.dart';
import 'package:mvi_flutter_sample/widgets/todo_list.dart';
import 'package:todos_app_core/todos_app_core.dart';

enum AppTab { todos, stats }

class HomeScreen extends StatefulWidget {
  final TodoListPresenter Function(TodoListView)? initPresenter;

  const HomeScreen({super.key = ArchSampleKeys.homeScreen, this.initPresenter});

  @override
  State<HomeScreen> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TodoListView {
  AppTab activeTab = AppTab.todos;
  late final TodoListPresenter presenter;

  @override
  void didChangeDependencies() {
    presenter = widget.initPresenter != null
        ? widget.initPresenter!(this)
        : TodoListPresenter(
            view: this,
            todosInteractor: Injector.of(context).todosInteractor,
            userInteractor: Injector.of(context).userInteractor,
          );

    presenter.setUp();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tearDown();
    presenter.tearDown();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TodoListModel>(
      stream: presenter,
      initialData: presenter.latest,
      builder: (context, modelSnapshot) {
        final data = modelSnapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(BlocLocalizations.of(context).appTitle),
            actions: [
              FilterButton(
                isActive: activeTab == AppTab.todos,
                activeFilter: data.activeFilter,
                onSelected: updateFilter.add,
              ),
              ExtraActionsButton(
                allComplete: data.allComplete,
                hasCompletedTodos: data.hasCompletedTodos,
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
          body: data.loading
              ? LoadingSpinner(key: ArchSampleKeys.todosLoading)
              : activeTab == AppTab.todos
              ? TodoList(
                  loading: data.loading,
                  addTodo: addTodo.add,
                  updateTodo: updateTodo.add,
                  deleteTodo: deleteTodo.add,
                  todos: data.visibleTodos,
                )
              : StatsCounter(),
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
            currentIndex: AppTab.values.indexOf(activeTab),
            onTap: (index) {
              setState(() {
                activeTab = AppTab.values[index];
              });
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
  }
}

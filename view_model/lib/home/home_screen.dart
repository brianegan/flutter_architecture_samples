import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';

import '../details_screen.dart';
import '../localization.dart';
import '../todo.dart';
import '../todo_list_state.dart';
import '../todo_list_view_model.dart';
import 'extra_actions_button.dart';
import 'filter_button.dart';
import 'stats_view.dart';
import 'todo_list_view.dart';

class HomeScreen extends StatefulWidget {
  final TodosRepository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with ViewModelStateMixin<HomeScreen> {
  HomeScreenTab _tab = HomeScreenTab.todos;

  TodoListViewModel get todoListViewModel =>
      viewModelBinding.read(todoListViewModelSpec(widget.repository));

  @override
  Widget build(BuildContext context) {
    return StateViewModelSelector<TodoListState, TodoListState>(
      viewModel: todoListViewModel,
      selector: (state) => state,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(ViewModelLocalizations.of(context).appTitle),
            actions: [
              FilterButton(
                filter: state.filter,
                isActive: _tab == HomeScreenTab.todos,
                onSelected: (filter) => todoListViewModel.setFilter(filter),
              ),
              ExtraActionsButton(
                hasActiveTodos: state.hasActiveTodos,
                onClearCompleted: () {
                  unawaited(todoListViewModel.clearCompleted());
                },
                onToggleAll: () {
                  unawaited(todoListViewModel.toggleAll());
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () =>
                Navigator.pushNamed(context, ArchSampleRoutes.addTodo),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
            child: const Icon(Icons.add),
          ),
          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    key: ArchSampleKeys.todosLoading,
                  ),
                )
              : switch (_tab) {
                  HomeScreenTab.stats => StatsView(
                    numActive: state.numActive,
                    numCompleted: state.numCompleted,
                  ),
                  HomeScreenTab.todos => TodoListView(
                    todos: state.visibleTodos,
                    onRemove: _removeTodo,
                    onTodoSelected: (todo) => _openDetails(context, todo),
                    onTodoCompleteChanged: (id, complete) {
                      unawaited(
                        todoListViewModel.setTodoComplete(id, complete),
                      );
                    },
                  ),
                },
          bottomNavigationBar: BottomNavigationBar(
            key: ArchSampleKeys.tabs,
            currentIndex: HomeScreenTab.values.indexOf(_tab),
            onTap: (index) {
              setState(() => _tab = HomeScreenTab.values[index]);
            },
            items: [
              for (final tab in HomeScreenTab.values)
                BottomNavigationBarItem(
                  icon: Icon(tab.icon, key: tab.key),
                  label: tab.title,
                ),
            ],
          ),
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    unawaited(todoListViewModel.removeTodo(todo.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: const Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo.task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          key: ArchSampleKeys.snackbarAction(todo.id),
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () {
            unawaited(todoListViewModel.addTodo(todo));
          },
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, Todo todo) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DetailsScreen(
          todoId: todo.id,
          repository: widget.repository,
          onRemove: (removedTodo) {
            Navigator.pop(context);
            _removeTodo(context, removedTodo);
          },
        ),
      ),
    );
  }
}

enum HomeScreenTab { todos, stats }

extension on HomeScreenTab {
  IconData get icon =>
      this == HomeScreenTab.todos ? Icons.list : Icons.show_chart;

  String get title => this == HomeScreenTab.todos ? 'Todos' : 'Stats';

  Key get key => this == HomeScreenTab.stats
      ? ArchSampleKeys.statsTab
      : ArchSampleKeys.todoTab;
}

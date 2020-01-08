import 'package:flutter/material.dart' hide Action;
import 'package:provider/provider.dart';
import 'package:provider_sample/home/stats_view.dart';
import 'package:provider_sample/home/todo_list_view.dart';
import 'package:provider_sample/localization.dart';
import 'package:provider_sample/todo_list_model.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../models.dart';
import 'extra_actions_button.dart';
import 'filter_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Because the state of the tabs is only a concern to the HomeScreen Widget,
  // it is stored as local state rather than in the TodoListModel.
  final _tab = ValueNotifier(_HomeScreenTab.todos);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ProviderLocalizations.of(context).appTitle),
        actions: <Widget>[
          AnimatedBuilder(
            animation: _tab,
            builder: (_, __) => FilterButton(
              isActive: _tab.value == _HomeScreenTab.todos,
            ),
          ),
          const ExtraActionsButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: ArchSampleKeys.addTodoFab,
        onPressed: () => Navigator.pushNamed(context, ArchSampleRoutes.addTodo),
        tooltip: ArchSampleLocalizations.of(context).addTodo,
        child: const Icon(Icons.add),
      ),
      body: Selector<TodoListModel, bool>(
        selector: (context, model) => model.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(
                key: ArchSampleKeys.todosLoading,
              ),
            );
          }

          return AnimatedBuilder(
            animation: _tab,
            builder: (context, _) {
              switch (_tab.value) {
                case _HomeScreenTab.stats:
                  return const StatsView();
                case _HomeScreenTab.todos:
                default:
                  return TodoListView(
                    onRemove: (context, todo) {
                      Provider.of<TodoListModel>(context, listen: false)
                          .removeTodo(todo);
                      _showUndoSnackbar(context, todo);
                    },
                  );
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: ArchSampleKeys.tabs,
        currentIndex: _HomeScreenTab.values.indexOf(_tab.value),
        onTap: (int index) {
          _tab.value = _HomeScreenTab.values[index];
        },
        items: [
          for (final tab in _HomeScreenTab.values)
            BottomNavigationBarItem(
              icon: Icon(tab.icon, key: tab.key),
              title: Text(tab.title),
            )
        ],
      ),
    );
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    Scaffold.of(context).showSnackBar(
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
          onPressed: () =>
              Provider.of<TodoListModel>(context, listen: false).addTodo(todo),
        ),
      ),
    );
  }
}

enum _HomeScreenTab { todos, stats }

extension TabExtensions on _HomeScreenTab {
  IconData get icon {
    return (this == _HomeScreenTab.todos) ? Icons.list : Icons.show_chart;
  }

  String get title {
    return this == _HomeScreenTab.todos ? 'Todos' : 'Stats';
  }

  Key get key {
    return this == _HomeScreenTab.stats
        ? ArchSampleKeys.statsTab
        : ArchSampleKeys.todoTab;
  }
}

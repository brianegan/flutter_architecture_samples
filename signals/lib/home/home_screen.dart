import 'package:flutter/material.dart' hide Action;
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_sample/localization.dart';
import 'package:signals_sample/todo_list_controller.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../todo.dart';
import 'extra_actions_button.dart';
import 'filter_button.dart';
import 'stats_view.dart';
import 'todo_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Because the state of the tabs is only a concern to the HomeScreen Widget,
  // it is stored as local state rather than in the TodoListController.
  final _tab = Signal(HomeScreenTab.todos);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TodoListController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(SignalsLocalizations.of(context).appTitle),
        actions: <Widget>[
          Watch(
            (_) => FilterButton(isActive: _tab.value == HomeScreenTab.todos),
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
      body: FutureBuilder<void>(
        future: controller.initializingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(
                key: ArchSampleKeys.todosLoading,
              ),
            );
          }

          return Watch((context) {
            switch (_tab.value) {
              case HomeScreenTab.stats:
                return const StatsView();
              case HomeScreenTab.todos:
                return TodoListView(
                  onRemove: (context, todo) {
                    controller.todos.remove(todo);
                    _displayRemovalNotification(context, todo);
                  },
                );
            }
          });
        },
      ),
      bottomNavigationBar: Watch((context) {
        return BottomNavigationBar(
          key: ArchSampleKeys.tabs,
          currentIndex: HomeScreenTab.values.indexOf(_tab.value),
          onTap: (int index) {
            _tab.value = HomeScreenTab.values[index];
          },
          items: [
            for (final tab in HomeScreenTab.values)
              BottomNavigationBarItem(
                icon: Icon(tab.icon, key: tab.key),
                label: tab.title,
              ),
          ],
        );
      }),
    );
  }

  void _displayRemovalNotification(BuildContext context, Todo todo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: const Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo.task.value),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          key: ArchSampleKeys.snackbarAction(todo.id.value),
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () => context.read<TodoListController>().todos.add(todo),
        ),
      ),
    );
  }
}

enum HomeScreenTab { todos, stats }

extension TabExtensions on HomeScreenTab {
  IconData get icon {
    return (this == HomeScreenTab.todos) ? Icons.list : Icons.show_chart;
  }

  String get title {
    return this == HomeScreenTab.todos ? 'Todos' : 'Stats';
  }

  Key get key {
    return this == HomeScreenTab.stats
        ? ArchSampleKeys.statsTab
        : ArchSampleKeys.todoTab;
  }
}

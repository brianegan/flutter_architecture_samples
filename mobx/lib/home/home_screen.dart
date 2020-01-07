import 'package:flutter/material.dart' hide Action;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_sample/home/stats_view.dart';
import 'package:mobx_sample/home/todo_list_view.dart';
import 'package:mobx_sample/localization.dart';
import 'package:mobx_sample/models/todo.dart';
import 'package:mobx_sample/stores/todo_store.dart';
import 'package:provider/provider.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'extra_actions_button.dart';
import 'filter_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Because the state of the tabs is only a concern to the HomeScreen Widget,
  // it is stored as local state rather than in the TodoStore.
  //
  // In this case, there's no need for a fully generated Store class. Just
  // create a mobx Observable locally as part of the state class and use the
  // Observer Widget to listen for changes as with any Observable.
  final _tab = Observable(_HomeScreenTab.todos);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MobxLocalizations.of(context).appTitle),
        actions: <Widget>[
          Observer(
            builder: (_) => FilterButton(
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
      body: Observer(
        builder: (context) {
          final store = Provider.of<TodoStore>(context);

          if (store.loader.status == FutureStatus.pending) {
            return Center(
              child: CircularProgressIndicator(
                key: ArchSampleKeys.todosLoading,
              ),
            );
          }

          switch (_tab.value) {
            case _HomeScreenTab.stats:
              return const StatsView();
            case _HomeScreenTab.todos:
            default:
              return TodoListView(
                onRemove: (context, todo) {
                  store.todos.remove(todo);
                  _displayRemovalNotification(context, todo);
                },
              );
          }
        },
      ),
      bottomNavigationBar: Observer(
        builder: (context) {
          return BottomNavigationBar(
            key: ArchSampleKeys.tabs,
            currentIndex: _HomeScreenTab.values.indexOf(_tab.value),
            onTap: (int index) {
              runInAction(() => _tab.value = _HomeScreenTab.values[index]);
            },
            items: [
              for (final tab in _HomeScreenTab.values)
                BottomNavigationBarItem(
                  icon: Icon(tab.icon, key: tab.key),
                  title: Text(tab.title),
                )
            ],
          );
        },
      ),
    );
  }

  void _displayRemovalNotification(BuildContext context, Todo todo) {
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
          onPressed: () {
            Provider.of<TodoStore>(context, listen: false).todos.add(todo);
          },
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

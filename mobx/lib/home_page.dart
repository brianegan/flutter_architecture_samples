import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_sample/model/todo.dart';
import 'package:mobx_sample/model/todo_manager_store.dart';
import 'package:mobx_sample/routes.dart';
import 'package:mobx_sample/stats_counter.dart';
import 'package:mobx_sample/todo_list_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoStoreManager = Provider.of<TodoManagerStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos with MobX'),
        actions: <Widget>[
          Observer(
            builder: (_) => todoStoreManager.activeTab == TabType.todos
                ? PopupMenuButton(
                    icon: Icon(Icons.filter_list),
                    initialValue: todoStoreManager.filter,
                    onSelected: todoStoreManager.changeFilter,
                    itemBuilder: (_) => <PopupMenuEntry<VisibilityFilter>>[
                      PopupMenuItem(
                        value: VisibilityFilter.all,
                        child: Text('Show All'),
                      ),
                      PopupMenuItem(
                        value: VisibilityFilter.pending,
                        child: Text('Show Active'),
                      ),
                      PopupMenuItem(
                        value: VisibilityFilter.completed,
                        child: Text('Show Completed'),
                      ),
                    ],
                  )
                : SizedBox(),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_horiz),
            onSelected: (value) => performAction(context, value),
            itemBuilder: (_) => <PopupMenuEntry>[
              PopupMenuItem(
                value: ListAction.markAllComplete,
                child: Text('Mark All Complete'),
              ),
              PopupMenuItem(
                value: ListAction.clearCompleted,
                child: Text('Clear Completed'),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, addTodoPageRoute);
        },
      ),
      body: Observer(
        builder: (context) {
          final list = Provider.of<TodoManagerStore>(context);

          if (list.loader.status == FutureStatus.pending) {
            return Center(child: CircularProgressIndicator());
          }

          return todoStoreManager.activeTab == TabType.todos
              ? TodoListView(
                  onRemove: (context, todo) {
                    todoStoreManager.removeTodo(todo);
                    displayRemovalNotification(context, todo);
                  },
                )
              : StatsCounter();
        },
      ),
      bottomNavigationBar: Observer(
          builder: (context) => BottomNavigationBar(
                currentIndex:
                    TabType.values.indexOf(todoStoreManager.activeTab),
                onTap: (int index) {
                  todoStoreManager.updateTab(TabType.values[index]);
                },
                items: TabType.values
                    .map(
                      (TabType tab) => BottomNavigationBarItem(
                          icon: Icon(tab.icon), title: Text(tab.title)),
                    )
                    .toList(),
              )),
    );
  }

  displayRemovalNotification(BuildContext context, Todo todo) {
    final todoList = Provider.of<TodoManagerStore>(context, listen: false);

    final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Removed Todo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(todo.title),
        ],
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: todoList.applyUndo,
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void performAction(BuildContext context, ListAction value) {
    final list = Provider.of<TodoManagerStore>(context, listen: false);

    if (value == ListAction.markAllComplete) {
      list.markAllComplete();
    } else if (value == ListAction.clearCompleted) {
      list.clearCompleted();
    }
  }
}

extension TabIcon on TabType {
  IconData get icon {
    return (this == TabType.todos) ? Icons.list : Icons.show_chart;
  }

  String get title {
    return this == TabType.todos ? 'Todos' : 'Stats';
  }
}

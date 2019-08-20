import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_sample/add_todo_page.dart';
import 'package:mobx_sample/model/layout.dart';
import 'package:mobx_sample/model/todo.dart';
import 'package:mobx_sample/model/todo_list.dart';
import 'package:mobx_sample/stats_counter.dart';
import 'package:mobx_sample/todo_details_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context);
    final layoutStore = Provider.of<LayoutStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos with MobX'),
        actions: <Widget>[
          layoutStore.activeTab == TabType.todos
              ? Observer(
                  builder: (_) => PopupMenuButton(
                    icon: Icon(Icons.filter_list),
                    initialValue: todoList.filter,
                    onSelected: todoList.changeFilter,
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
                  ),
                )
              : SizedBox(),
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
          Navigator.pushNamed(context, AddTodoPage.routeName);
        },
      ),
      body: Observer(
        builder: (context) {
          final list = Provider.of<TodoList>(context);

          if (list.loader.status == FutureStatus.pending) {
            return Center(child: CircularProgressIndicator());
          }

          return layoutStore.activeTab == TabType.todos
              ? TodoListView(
                  onRemove: (context, todo) {
                    todoList.removeTodo(todo);
                    displayRemovalNotification(context, todo);
                  },
                )
              : StatsCounter();
        },
      ),
      bottomNavigationBar: Observer(
          builder: (context) => BottomNavigationBar(
                currentIndex: TabType.values.indexOf(layoutStore.activeTab),
                onTap: (int index) {
                  layoutStore.updateTab(TabType.values[index]);
                },
                items: TabType.values
                    .map(
                      (TabType tab) => BottomNavigationBarItem(
                          icon: Icon(
                            tab == TabType.todos
                                ? Icons.list
                                : Icons.show_chart,
                          ),
                          title:
                              Text(tab == TabType.todos ? 'Todos' : 'Stats')),
                    )
                    .toList(),
              )),
    );
  }

  displayRemovalNotification(BuildContext context, Todo todo) {
    final todoList = Provider.of<TodoList>(context);

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
    final list = Provider.of<TodoList>(context);

    if (value == ListAction.markAllComplete) {
      list.markAllComplete();
    } else if (value == ListAction.clearCompleted) {
      list.clearCompleted();
    }
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final list = Provider.of<TodoList>(context);

        if (list.loader.status == FutureStatus.pending) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          );
        }

        return Container();
      },
    );
  }
}

class TodoListView extends StatelessWidget {
  final void Function(BuildContext context, Todo todo) onRemove;

  TodoListView({@required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final todoList = Provider.of<TodoList>(context);
        final todos = todoList.visibleTodos;

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (_, index) {
            final todo = todos[index];

            return Observer(
              builder: (context) => Dismissible(
                key: Key(todo.id),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd ||
                      direction == DismissDirection.endToStart) {
                    onRemove(context, todo);
                  }
                },
                child: ListTile(
                  title: Text(
                    todo.title,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: todo.hasNotes
                      ? Text(
                          todo.notes,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TodoDetailsPage(
                                  todo: todo,
                                  onRemove: () {
                                    Navigator.pop(context);
                                    onRemove(context, todo);
                                  },
                                )));
                  },
                  leading: Checkbox(
                    value: todo.done,
                    onChanged: (value) => todo.done = value,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

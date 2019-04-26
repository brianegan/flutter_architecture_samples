import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_sample/add_todo_page.dart';
import 'package:mobx_sample/todo_stores.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos with MobX'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            itemBuilder: (_) => List<PopupMenuEntry>(),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_horiz),
            itemBuilder: (_) => List<PopupMenuEntry>(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTodoPage(
                        onAdd: (todo) {
                          todoList.addTodo(todo);
                          Navigator.pop(context);
                        },
                      )));
        },
      ),
      body: Column(
        children: <Widget>[
          LoadingIndicator(),
          Expanded(
            child: TodoListView(
              onRemove: (context, todo) {
                todoList.removeTodo(todo);
                displaySnackBar(context, todo);
              },
            ),
          ),
        ],
      ),
    );
  }

  displaySnackBar(BuildContext context, Todo todo) {
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
  void Function(BuildContext context, Todo todo) onRemove;

  TodoListView({@required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<TodoList>(context);

    return Observer(
      builder: (_) => ListView.builder(
            itemCount: todoList.todos.length,
            itemBuilder: (_, index) {
              final todo = todoList.todos[index];

              return Observer(
                  builder: (context) => Dismissible(
                        key: Key(todo.id),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            onRemove(context, todo);
                          }
                        },
                        child: ListTile(
                          title: Text(todo.title),
                          subtitle:
                              todo.notes == null ? null : Text(todo.notes),
                          leading: Checkbox(
                            value: todo.done,
                            onChanged: todo.markDone,
                          ),
                        ),
                      ));
            },
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/actions/add_todo.dart';
import 'package:redurx_sample/actions/delete_todo.dart';
import 'package:redurx_sample/actions/update_todo.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/todo.dart';
import 'package:redurx_sample/screens/detail_screen.dart';
import 'package:redurx_sample/widgets/todo_item.dart';

import 'package:built_collection/built_collection.dart';
import 'package:tuple/tuple.dart';

class TodoList extends StatelessWidget {
  TodoList() : super(key: ArchSampleKeys.todoList);

  @override
  Widget build(BuildContext context) {
    return Connect<AppState, Tuple2<bool, BuiltList<Todo>>>(
      convert: (state) => Tuple2(state.isLoading, state.filteredTodosSelector),
      where: (prev, next) => next != prev,
      builder: (props) {
        return Container(
          child: props.item1
              ? Center(
                  child: CircularProgressIndicator(
                  key: ArchSampleKeys.todosLoading,
                ))
              : ListView.builder(
                  key: ArchSampleKeys.todoList,
                  itemCount: props.item2.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = props.item2[index];

                    return TodoItem(
                      todo: todo,
                      onDismissed: (direction) {
                        _removeTodo(context, todo);
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return DetailScreen(id: todo.id);
                            },
                          ),
                        ).then((removedTodo) {
                          if (removedTodo != null) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                key: ArchSampleKeys.snackbar,
                                duration: Duration(seconds: 2),
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                content: Text(
                                  ArchSampleLocalizations.of(context)
                                      .todoDeleted(todo.task),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                action: SnackBarAction(
                                  label:
                                      ArchSampleLocalizations.of(context).undo,
                                  onPressed: () {
                                    Provider.dispatch<AppState>(
                                        context, AddTodo(todo));
                                  },
                                ),
                              ),
                            );
                          }
                        });
                      },
                      onCheckboxChanged: (complete) {
                        Provider.dispatch<AppState>(
                            context,
                            UpdateTodo(
                                todo.id,
                                todo.rebuild(
                                    (b) => b..complete = !todo.complete)));
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    Provider.dispatch<AppState>(context, DeleteTodo(todo.id));

    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).backgroundColor,
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todo.task),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () {
            Provider.dispatch<AppState>(context, AddTodo(todo));
          },
        ),
      ),
    );
  }
}

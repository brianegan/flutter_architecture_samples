import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scoped_model_sample/models.dart';
import 'package:scoped_model_sample/screens/add_edit_screen.dart';
import 'package:scoped_model_sample/todo_list_model.dart';

class DetailScreen extends StatelessWidget {
  final String todoId;

  DetailScreen({
    @required this.todoId,
  })
      : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        // fallback to empty item. When deleting it, it is null before the screen is gone
        var todo = model.todoById(todoId) ?? new Todo('');
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(ArchSampleLocalizations.of(context).todoDetails),
            actions: [
              new IconButton(
                key: ArchSampleKeys.deleteTodoButton,
                tooltip: ArchSampleLocalizations.of(context).deleteTodo,
                icon: new Icon(Icons.delete),
                onPressed: () {
                  model.removeTodo(todo);
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
          body: new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new ListView(
              children: [
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Padding(
                      padding: new EdgeInsets.only(right: 8.0),
                      child: new Checkbox(
                        value: todo.complete,
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        onChanged: (complete) {
                          model.updateTodo(todo.copy(complete: !todo.complete));
                        },
                      ),
                    ),
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Padding(
                            padding: new EdgeInsets.only(
                              top: 8.0,
                              bottom: 16.0,
                            ),
                            child: new Text(
                              todo.task,
                              key: ArchSampleKeys.detailsTodoItemTask,
                              style: Theme.of(context).textTheme.headline,
                            ),
                          ),
                          new Text(
                            todo.note,
                            key: ArchSampleKeys.detailsTodoItemNote,
                            style: Theme.of(context).textTheme.subhead,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            tooltip: ArchSampleLocalizations.of(context).editTodo,
            child: new Icon(Icons.edit),
            key: ArchSampleKeys.editTodoFab,
            onPressed: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) {
                    return new AddEditScreen(
                      todoId: todoId,
                      key: ArchSampleKeys.editTodoScreen,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
